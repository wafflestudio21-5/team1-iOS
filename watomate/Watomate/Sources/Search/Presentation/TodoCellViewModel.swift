//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoCellViewModel: Identifiable {
    private let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    let id = UUID()
    
}
