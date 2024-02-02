//
//  UserGoal.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct UserGoal {
    let title: String
    let color: String
    let visibility: String
    let todos: [UserTodo]
}

struct UserTodo {
    let id: Int
    let title: String
    let color: String
    let isCompleted: Bool
    let likes: [SearchLike]
}
