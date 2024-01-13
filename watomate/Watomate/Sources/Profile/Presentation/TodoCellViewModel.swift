//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoCellViewModel {
    private var todo: Todo
    weak var delegate: (any TodoCellViewModelDelegate)?

    init(todo: Todo) {
        self.todo = todo
    }

    var id: Int {
        todo.id
    }
    
    var goal: Int {
        todo.goal
    }

    var isComplete: Bool {
        get { todo.isCompleted }
        set {
            todo.isCompleted = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }

    var title: String {
        get { todo.title }
        set {
            todo.title = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }

    var memo: String? {
        get { todo.description }
        set {
            todo.description = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }

    var isMemoHidden: Bool {
        todo.description == nil
    }

    func addNewTodoItem() {
        delegate?.todoCellViewModelDidReturnTitle(self)
    }

    func endEditingTitle(with title: String?) {
        delegate?.todoCellViewModel(self, didEndEditingWith: title)
    }
}

protocol TodoCellViewModelDelegate: AnyObject {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem: Todo)
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel)
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?)
}
