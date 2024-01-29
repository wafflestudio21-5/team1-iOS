//
//  Todo.swift
//  Watomate
//
//  Created by 권현구 on 1/11/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct Goal {
    let id: Int
    var title: String
    var visibility: Visibility
    var color: String
//    let createdAt: String
    var todos: [Todo]
}

enum Visibility {
    case PB
    case PR
    case FL
}

struct Todo: Codable {
    let uuid: UUID
    var id: Int?
    var title: String
    var color: String
    var description: String?
    var reminder: String?
//    let createdAt: String
//    var date: Date?
    var isCompleted: Bool
    var goal: Int
    var likes: [Like]
}

extension Todo {
    static func placeholderItem(with goal: Goal) -> Self {
        .init(uuid: UUID(), id: nil, title: "", color: goal.color, isCompleted: false, goal: goal.id, likes: [])
    }
}

struct Like: Codable {
    let userId: Int
    let emoji: String
}
