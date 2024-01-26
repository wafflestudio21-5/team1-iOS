//
//  DiaryDTO.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct DiaryCreateDTO: Codable {
    let description: String
    let visibility: String?
    let mood: Int?
    let color: String?
    let emoji: String?
    let image: [String]?
    let created_by: Int
    let date: String
}


struct DiaryDTO: Codable {
    let id: Int
    let description: String
    let visibility: String
    let mood: Int
    let color: String
    let emoji: String
    let image: [String]?
    let created_by: Int
    let date: String
    let likes: [LikeDTO]
    let comments: [CommentDTO]

    func toDomain() -> Diary {
        let convertedLikes = likes.map { $0.toDomain() }
        let convertedComments = comments.map { $0.toDomain() }
        return Diary(id: id, description: description, visibility: visibility, mood: mood, color: color, emoji: emoji, image: image, created_by: created_by, date: date, likes: convertedLikes, comments: convertedComments)
    }
}

struct LikeDTO: Codable {
    let user: Int
    let emoji: String
    func toDomain() -> Like {
       return Like(user: user, emoji: emoji)
   }
    
}

struct CommentDTO: Codable {
    let id: Int
    let created_at_iso: String
    let user: Int
    let description: String
    let likes: [LikeDTO]
    func toDomain() -> Comment {
        return Comment(id: id, created_at_iso: created_at_iso, user: user, description: description, likes: likes.map { $0.toDomain() })
    }
}

enum DiaryVisibility: String, Codable {
    case PB = "전체공개"
    case PR = "나만 보기"
    case FL = "팔로워 공개"
    case ND //not declared
}


enum DiaryEmoji: String {
    case happy = "😊"
    case angry = "😠"
    case pleading = "🥺"
    case laughing = "😂"
    case books = "📚"
    case note = "📝"
    case star = "🌟"
    case island = "🏝️"
    case guitar = "🎸"
    case heart = "❤️"
}

