//
//  TodoCellViewModel.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Combine

class TodoCellViewModel: ViewModelType, Hashable {
    lazy var newlyAdded: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
    
    static func == (lhs: TodoCellViewModel, rhs: TodoCellViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    
    enum Input {
    }
    
    enum Output {
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    private var todo: Todo
    weak var delegate: (any TodoCellViewModelDelegate)?

    init(todo: Todo) {
        self.todo = todo
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return output.eraseToAnyPublisher()
    }
    
    var uuid: UUID {
        todo.uuid
    }

    var id: Int? {
        get { todo.id }
        set {
            todo.id = newValue
        }
    }
    
    var goal: Int {
        todo.goal
    }

    var isCompleted: Bool {
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
        }
    }
    
    var color: String {
        get { todo.color }
        set {
            todo.color = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }

    var memo: String? {
        get { todo.description }
        set {
            todo.description = newValue
        }
    }
    
    var reminder: String? {
        get { todo.reminder }
        set {
            todo.reminder = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }
    
    var date: String? {
        get { todo.date }
        set {
            todo.date = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }
    
    var likes: [Like] {
        get { todo.likes }
        set {
            todo.likes = newValue
            delegate?.todoCellViewModel(self, didUpdateItem: todo)
        }
    }

    var isMemoHidden: Bool {
        guard let description = todo.description else { return true }
        return description.isEmpty
    }
    
    var isReminderHidden: Bool {
        guard let reminder = todo.reminder else { return true }
        return reminder.isEmpty
    }

    func addNewTodoItem() {
        delegate?.todoCellViewModelDidReturnTitle(self)
    }

    func endEditingTitle(with title: String?) {
        delegate?.todoCellViewModel(self, didEndEditingTitleWith: title)
    }
    
    func navigateToDetail() {
        delegate?.todoCellViewModelNavigateToDetail(self)
    }
}

protocol TodoCellViewModelDelegate: AnyObject {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem: Todo)
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel)
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingTitleWith title: String?)
    func todoCellViewModelNavigateToDetail(_ viewModel: TodoCellViewModel)
}
