//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoSectionViewModel: Identifiable {
    private let todoUser: TodoUser
    var todoCells = [SearchTodoCellViewModel]()
    
    init(todoUser: TodoUser) {
        self.todoUser = todoUser
        for todo in todoUser.todos {
            todoCells.append(SearchTodoCellViewModel(todo: todo))
        }
    }
    
    let id = UUID()
    
    var username: String {
        todoUser.username
    }
    
    var profilePic: String? {
        todoUser.profilePic
    }
    
    var todoCount: Int {
        todoCells.count
    }
    
    func viewModel(at indexPath: IndexPath) -> SearchTodoCellViewModel {
        return todoCells[indexPath.row]
    }
    
}
