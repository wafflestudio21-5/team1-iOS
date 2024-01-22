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
    
}

struct DiaryFeedResponseDto: Decodable {
    let next, previous: String?
    let results: [DiaryDto]
    
    func toDomain() -> DiariesPage {
        return .init(nextUrl: next,
                     results: results.map{ $0.toDomain() })
    }
    
    struct DiaryDto: Decodable {
        let id: Int
        let description: String
        let visibility: String
        let mood: Int
        let color: String
        let emoji: Int
        let image: String?
        let date: String
        let likes: [LikeDto]
        let comments: [CommentDto]
        
        func toDomain() -> Diary {
            return .init(id: id,
                         description: description,
                         visibility: visibility,
                         mood: mood,
                         color: color,
                         emoji: emoji,
                         image: image,
                         date: date,
                         likes: likes.map{ $0.toDomain() },
                         comments: comments.map{ $0.toDomain() })
        }
        
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
