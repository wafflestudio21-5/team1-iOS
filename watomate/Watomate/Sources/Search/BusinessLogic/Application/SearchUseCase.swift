//
//  SearchUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class SearchUseCase {
    private let searchRepository: SearchRepositoryProtocol
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func getUserInfo(id: Int) async throws -> UserInfo {
        let userInfo = try await searchRepository.getUserInfo(id: id)
        return UserInfo(id: userInfo.id, tedoori: userInfo.tedoori, goalColors: userInfo.goalColors, intro: userInfo.intro, username: userInfo.username, profilePic: userInfo.profilePic, followerCount: userInfo.followerCount, followingCount: userInfo.followingCount)
    }
    
    func getInitialUsers() async throws -> UsersPage {
        var usersPage = try await searchRepository.getInitialUsers()
        return usersPage
    }
    
    func getMoreUsers(nextUrl: String) async throws -> UsersPage {
        var usersPage = try await searchRepository.getMoreUsers(url: nextUrl)
        return usersPage
    }
    
    func getInitialDiaries(id: Int) async throws -> DiariesPage {
        let diariesPage = try await searchRepository.getInitialDiaries(id: id)
        return diariesPage
    }
    
    func getMoreDiaries(nextUrl: String) async throws -> DiariesPage {
        let diariesPage = try await searchRepository.getMoreDiaries(url: nextUrl)
        return diariesPage
    }
    
    func searchInitialUsers(username: String) async throws -> UsersPage {
        var usersPage = try await searchRepository.searchInitialUsers(username: username)
        return usersPage
    }
    
    func getTodoFeed() async throws -> TodoPage {
        let todoPage = try await searchRepository.getTodoFeed()
        return todoPage
    }
    
    func getMoreTodo(nextUrl: String) async throws -> TodoPage {
        let todoPage = try await searchRepository.getMoreTodo(url: nextUrl)
        return todoPage
    }
    
    func searchInitialTodo(title: String) async throws -> TodoPage {
        let todoPage = try await searchRepository.searchInitialTodo(title: title)
        return todoPage
    }

    func postLike(diaryId: Int, user: Int, emoji: String) async throws {
        try await searchRepository.postLike(diaryId: diaryId, user: user, emoji: emoji)
    }
    
    func commentLike(commentId: Int, user: Int, emoji: String) async throws {
        try await searchRepository.commentLike(commentId: commentId, user: user, emoji: emoji)
    }
    
    func postComment(diaryId: Int, userId: Int, description: String) async throws -> SearchComment {
        return try await searchRepository.postComment(diaryId: diaryId, user: userId, description: description)
    }
    
    func editComment(commentId: Int, description: String) async throws {
        try await searchRepository.editComment(commentId: commentId, description: description)
    }
    
    func deleteComment(commentId: Int) async throws {
        try await searchRepository.deleteComment(commentId: commentId)
    }
}
