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
    
    var todos: [SearchTodo] {
        todoUser.todos
    }
    
    var todoCount: Int {
        todos.count
    }
    
    func viewModel(at indexPath: IndexPath) -> SearchTodoCellViewModel {
        return SearchTodoCellViewModel(todo: todos[indexPath.row])
    }
    
}
