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
    let created_at_iso: String
    let todos: [TodoDto]
}

struct TodoDto: Codable {
    let id: Int
    let title: String
    let description: String
    let reminder_iso: String?
    let created_at_iso: String
    let date: String
    let is_completed: Bool
    let likes: [LikeDto]
}

struct LikeDto: Codable {
    let user: Int
}
