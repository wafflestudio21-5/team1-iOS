//
//  GoalsDto.swift
//  Watomate
//
//  Created by 권현구 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

typealias GoalsResponseDto = [GoalResponseDto]

struct GoalResponseDto: Codable {
    let id: Int
    let title: String
    let visibility: String
    let color: String
//    let created_at_iso: String
    let todos: [TodoDto]
    
    func toDomain() -> Goal {
        return Goal(id: id,
                    title: title,
                    visibility: Visibility(rawValue: visibility)!,
                    color: color,
                    todos: todos.map { $0.toDomain() }
                    )
    }
}

struct TodoDto: Codable {
    let id: Int
    let title: String
    let color: String
    let description: String
    let reminder: String?
    let reminder_iso: String?
    let date: String?
    let is_completed: Bool
    let goal: Int
    let likes: [LikeDto]
    
    func toDomain() -> Todo {
        return Todo(uuid: .init(), 
                    id: id,
                    title: title,
                    color: color,
                    description: description,
                    reminder: reminder,
                    reminderIso: reminder_iso,
                    date: date,
                    isCompleted: is_completed,
                    goal: goal,
                    likes: likes.map{ $0.toDomain() }
                    )
    }
}

struct LikeDto: Codable {
    let user: Int
    let emoji: String
    
    func toDomain() -> Like {
        return Like(userId: user, emoji: emoji)
    }
}
