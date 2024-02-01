//
//  SearchDto.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct UsersResponseDto: Decodable {
    let next, previous: String?
    let results: [UserDto]
    
    func toDomain() -> UsersPage {
        return .init(nextUrl: next,
                     results: results.map{ $0.toDomain() })
    }
    
}

struct UserInfoDto: Decodable {
    let user: Int
    let intro: String?
    let username: String
    let profilePic: String?
    let followerCount: Int
    let followingCount: Int
    
    func toDomain() -> UserInfo {
        return .init(id: user,
                     tedoori: false,
                     goalColors: [],
                     intro: intro,
                     username: username,
                     profilePic: profilePic,
                     followerCount: followerCount,
                     followingCount: followingCount)
    }
}

struct UserDto: Decodable {
    let user: Int
    let tedoori: Bool
    let goalColors: [String]
    let intro: String?
    let username: String
    let profilePic: String?
    let followerCount: Int
    let followingCount: Int
    
    func toDomain() -> UserInfo {
        return .init(id: user,
                     tedoori: tedoori,
                     goalColors: goalColors,
                     intro: intro,
                     username: username,
                     profilePic: profilePic,
                     followerCount: followerCount,
                     followingCount: followingCount)
    }
    
}

typealias UserGoalsResponseDto = [UserGoalResponseDto]

struct UserGoalResponseDto: Decodable {
    let visibility: String
    let color: String
}

struct DiaryFeedResponseDto: Decodable {
    let next, previous: String?
    let results: [DiaryDto]
    
    struct DiaryDto: Decodable {
        let id: Int 
        let createdBy: Int
        let description: String
        let visibility: String
        let mood: Int?
        let color: String
        let emoji: String
        let image: String?
        let date: String
        let likes: [SearchLikeDto]
        let comments: [CommentDto]
    }
}

struct SearchLikeDto: Decodable {
    let user: Int
    let emoji: String
    
    func toDomain() -> SearchLike {
        return .init(user: user, emoji: emoji)
    }
}

struct CommentDto: Decodable {
    let id: Int
    let createdAtIso: String
    let user: Int
    let username: String
    let profilePic: String?
    let description: String
    let likes: [SearchLikeDto]
    
    func toDomain() -> SearchComment {
        return .init(id: id,
                     createdAtIso: createdAtIso,
                     user: user,
                     username: username,
                     profilePic: profilePic,
                     description: description,
                     likes: likes.map{ $0.toDomain() })
    }
}

struct CommentEditDto: Decodable {
    let description: String
}

struct TodoFeedResponseDto: Decodable {
    let next, previous: String?
    let results: [TodoUserDto]
    
    func toDomain() -> TodoPage {
        return .init(nextUrl: next, results: results.map{ $0.toDomain() })
    }
    
    struct TodoUserDto: Decodable {
        let username: String
        let profilePic: String?
        let todos: [TodoDto]
        
        func toDomain() -> TodoUser {
            return .init(username: username, profilePic: profilePic, todos: todos.map{ $0.toDomain() })
        }
    }
    
    struct TodoDto: Decodable {
        let title, color: String
        let isCompleted: Bool
        
        func toDomain() -> SearchTodo {
            return .init(title: title, color: color, isCompleted: isCompleted)
        }
    }
}


