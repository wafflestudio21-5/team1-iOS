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

struct UserDto: Decodable {
    let user: Int
    let intro: String?
    let username: String
    let profilePic: String?
    
    func toDomain() -> UserInfo {
        return .init(id: user,
                     intro: intro,
                     username: username,
                     profilePic: profilePic)
    }
}

struct DiaryFeedResponseDto: Decodable {
    let next, previous: String?
    let results: [DiaryDto]
    
    struct DiaryDto: Decodable {
        let createdBy: Int
        let description: String
        let visibility: String
        let mood: Int
        let color: String
        let emoji: Int
        let image: String?
        let date: String
        let likes: [LikeDto]
        let comments: [CommentDto]
    }
}

struct LikeDto: Decodable {
    let user: Int
    let emoji: Int
    
    func toDomain() -> Like {
        return .init(user: user, emoji: emoji)
    }
}

struct CommentDto: Decodable {
    let createdAtIso: String
    let user: Int
    let description: String
    let likes: [LikeDto]
    
    func toDomain() -> Comment {
        return .init(createdAtIso: createdAtIso,
                     user: user,
                     description: description,
                     likes: likes.map{ $0.toDomain() })
    }
}

struct TodoFeedResponseDto: Decodable {
    let next, previous: String?
    let results: [TodoDFeedResultDto]
    
    struct TodoDFeedResultDto: Decodable {
        let username, intro: String
        let profilePic: String?
        let todos: [TodoDto]
    }
    
    struct TodoDto: Decodable {
        let id: Int
        let title, color, description: String
        let reminderISO: String?
        let createdAtISO, date: String
        let isCompleted: Bool
        let likes: [LikeDto]
    }
}


