//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class SearchTodoCellViewModel: Identifiable {
    private let todo: SearchTodo
    
    init(todo: SearchTodo) {
        self.todo = todo
    }
    
    let id = UUID()
    
    var title: String {
        todo.title
    }
    
    var color: String {
        todo.color
    }
    
    var isCompleted: Bool {
        todo.isCompleted
    }
    
}
