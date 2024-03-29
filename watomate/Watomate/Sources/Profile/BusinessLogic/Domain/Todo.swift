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
    var todos: [Todo]
}

struct GoalCreate {
    var title: String?
    var visibility: String?
    var color: String?
}

enum Visibility: String {
    case PB
    case PR
    case FL
    
    init?(rawValue: String) {
        switch rawValue {
        case "PB":
            self = .PB
        case "PR":
            self = .PR
        case "FL":
            self = .FL
        default:
            self = .FL
        }
    }
}

struct Todo: Codable {
    let uuid: UUID
    var id: Int?
    var title: String
    var color: String
    var description: String?
    var reminder: String?
    var reminderIso: String?
    var date: String?
    var isCompleted: Bool
    var goal: Int
    var likes: [Like]
}

extension Todo {
    static func placeholderItem(with goal: Goal) -> Self {
        .init(uuid: UUID(), id: nil, title: "", color: goal.color, isCompleted: false, goal: goal.id, likes: [])
    }
}
