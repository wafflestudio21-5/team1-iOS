//
//  TodoUser.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct TodoUser: Identifiable {
    let id = UUID()
    let username: String
    let profilePic: String?
    let todos: [SearchTodo]
}
