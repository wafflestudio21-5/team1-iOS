//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoUserCellViewModel: Identifiable {
    private let todoUser: TodoUser
    
    init(todoUser: TodoUser) {
        self.todoUser = todoUser
    }
    
    let id = UUID()
    
    var username: String {
        todoUser.username
    }
    
    var profilePic: String? {
        todoUser.profilePic
    }
    
}
