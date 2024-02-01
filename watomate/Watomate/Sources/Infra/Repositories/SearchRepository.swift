//
//  SearchRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol SearchRepositoryProtocol {
    func getUserInfo(id: Int) async throws -> UserInfo
    func getUserGoals(id: Int) async throws -> UserGoalsResponseDto
    func getInitialUsers() async throws -> UsersPage
    func getMoreUsers(url: String) async throws -> UsersPage
    func getInitialDiaries(id: Int) async throws -> DiariesPage
    func getMoreDiaries(url: String) async throws -> DiariesPage
    func getTodoFeed() async throws -> TodoPage
    func getMoreTodo(url: String) async throws -> TodoPage
    func searchInitialUsers(username: String) async throws -> UsersPage
    func searchInitialTodo(title: String) async throws -> TodoPage
    func postLike(diaryId: Int, user: Int, emoji: String) async throws
    func postComment(diaryId: Int, user: Int, description: String) async throws -> SearchComment
    func editComment(commentId: Int, description: String) async throws
    func deleteComment(commentId: Int) async throws
}

class SearchRepository: SearchRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getUserInfo(id: Int) async throws -> UserInfo {
        let dto = try await session.request(SearchRouter.getUserInfo(id: id))
            .serializingDecodable(UserInfoDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getUserGoals(id: Int) async throws -> UserGoalsResponseDto {
        let dto = try await session.request(SearchRouter.getUserGoals(id: id))
            .serializingDecodable(UserGoalsResponseDto.self, decoder: decoder).handlingError()
        return dto
    }
    
    func getInitialUsers() async throws -> UsersPage {
        let dto = try await session.request(SearchRouter.getAllUsers)
            .serializingDecodable(UsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getMoreUsers(url: String) async throws -> UsersPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(UsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getInitialDiaries(id: Int) async throws -> DiariesPage {
        let dto = try await session.request(SearchRouter.getDiaryFeed(id: id))
            .serializingDecodable(DiaryFeedResponseDto.self, decoder: decoder).handlingError()
        var diaries = [SearchDiary]()
        for diaryDto in dto.results {
            let user = try await getUserInfo(id: diaryDto.createdBy)
            diaries.append(SearchDiary(id: diaryDto.id,
                                       user: user,
                                 description: diaryDto.description,
                                       visibility: Visibility(rawValue: diaryDto.visibility) ?? .PR ,
                                 mood: diaryDto.mood,
                                       color: Color(rawValue: diaryDto.color) ?? Color.system,
                                 emoji: diaryDto.emoji,
                                 image: diaryDto.image,
                                 date: diaryDto.date,
                                 likes: diaryDto.likes.map{ $0.toDomain() },
                                 comments: diaryDto.comments.map{ $0.toDomain() }))
        }
        return DiariesPage(nextUrl: dto.next, results: diaries)
    }
    
    func getMoreDiaries(url: String) async throws -> DiariesPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(DiaryFeedResponseDto.self, decoder: decoder).handlingError()
        var diaries = [SearchDiary]()
        for diaryDto in dto.results {
            let user = try await getUserInfo(id: diaryDto.createdBy)
            diaries.append(SearchDiary(id: diaryDto.id, 
                                       user: user,
                                 description: diaryDto.description,
                                       visibility: Visibility(rawValue: diaryDto.visibility) ?? .PR,
                                 mood: diaryDto.mood,
                                 color: Color(rawValue: diaryDto.color) ?? Color.system,
                                 emoji: diaryDto.emoji,
                                 image: diaryDto.image,
                                 date: diaryDto.date,
                                 likes: diaryDto.likes.map{ $0.toDomain() },
                                 comments: diaryDto.comments.map{ $0.toDomain() }))
        }
        return DiariesPage(nextUrl: dto.next, results: diaries)
    }
    
    func searchInitialUsers(username: String) async throws -> UsersPage {
        let dto = try await session.request(SearchRouter.searchUser(username: username))
            .serializingDecodable(UsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getTodoFeed() async throws -> TodoPage {
        let dto = try await session.request(SearchRouter.getTodoFeed).serializingDecodable(TodoFeedResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getMoreTodo(url: String) async throws -> TodoPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(TodoFeedResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func searchInitialTodo(title: String) async throws -> TodoPage {
        let dto = try await session.request(SearchRouter.searchTodo(title: title))
            .serializingDecodable(TodoFeedResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func postLike(diaryId: Int, user: Int, emoji: String) async throws {
        try await session.request(SearchRouter.likeDiary(diaryId: diaryId, user: user, emoji: emoji)).serializingDecodable(SearchLikeDto.self, decoder: decoder).handlingError()
    }
    
    func postComment(diaryId: Int, user: Int, description: String) async throws -> SearchComment {
        let dto = try await session.request(SearchRouter.commentDiary(diaryId: diaryId, userId: user, description: description )).serializingDecodable(CommentDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func editComment(commentId: Int, description: String) async throws {
        try await session.request(SearchRouter.editComment(commentId: commentId, description: description)).serializingDecodable(CommentEditDto.self, decoder: decoder).handlingError()
    }
    
    func deleteComment(commentId: Int) async throws {
        try await session.request(SearchRouter.deleteComment(commentId: commentId)).serializingData().handlingError()
    }
}
