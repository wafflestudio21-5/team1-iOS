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
    func commentLike(commentId: Int, user: Int, emoji: String) async throws
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
        return DiariesPage(nextUrl: dto.next, results: dto.results
            .map{ SearchDiary(id: $0.id,
                              user: UserInfo(
                                id: $0.createdBy,
                                tedoori: $0.tedoori,
                                goalColors: [],
                                intro: nil,
                                username: $0.username,
                                profilePic: $0.profilePic,
                                followerCount: nil,
                                followingCount: nil
                              ),
                              description: $0.description,
                              visibility: Visibility(rawValue: $0.visibility) ?? .PR ,
                              mood: $0.mood,
                              color: Color(rawValue: $0.color) ?? Color.system,
                              emoji: $0.emoji,
                              image: $0.image,
                              date: $0.date,
                              likes: $0.likes.map{ $0.toDomain() },
                              comments: $0.comments.map{ $0.toDomain() })
            })
    }
    
    func getMoreDiaries(url: String) async throws -> DiariesPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(DiaryFeedResponseDto.self, decoder: decoder).handlingError()
        return DiariesPage(nextUrl: dto.next, results: dto.results
            .map{ SearchDiary(id: $0.id,
                              user: UserInfo(
                                id: $0.createdBy,
                                tedoori: $0.tedoori,
                                goalColors: [],
                                intro: nil,
                                username: $0.username,
                                profilePic: $0.profilePic,
                                followerCount: nil,
                                followingCount: nil
                              ),
                              description: $0.description,
                              visibility: Visibility(rawValue: $0.visibility) ?? .PR ,
                              mood: $0.mood,
                              color: Color(rawValue: $0.color) ?? Color.system,
                              emoji: $0.emoji,
                              image: $0.image,
                              date: $0.date,
                              likes: $0.likes.map{ $0.toDomain() },
                              comments: $0.comments.map{ $0.toDomain() })
            })
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
    
    func commentLike(commentId: Int, user: Int, emoji: String) async throws {
        try await session.request(SearchRouter.likeComment(commentId: commentId, user: user, emoji: emoji)).serializingDecodable(SearchLikeDto.self, decoder: decoder).handlingError()
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
