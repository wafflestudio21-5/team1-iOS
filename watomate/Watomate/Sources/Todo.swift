//
//  Todo.swift
//  Watomate
//
//  Created by 권현구 on 1/11/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct Goal: Hashable {
    let id: Int
    var title: String
    var visibility: Visibility
    var color: String
    let createdAt: String
    var todos: [Todo]
    
    static func ==(lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

enum Visibility {
    case PB
    case PR
    case FL
}

struct Todo: Codable, Identifiable, Hashable {
    let id: Int
    var title: String
    var description: String?
    var reminder: String?
    let createdAt: String
    var date: Date?
    var isCompleted: Bool
    var goal: Int
    var likes: [Like]
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

//extension Todo {
//    static func placeholderItem(at section: Int) -> Self {
//        .init(id: <#T##Int#>, title: <#T##String#>, createdAt: <#T##String#>, isCompleted: <#T##Bool#>, goal: <#T##Int#>, likes: <#T##[Like]#>)
//    }
//}

struct Like: Codable {
    let userId: Int
}
