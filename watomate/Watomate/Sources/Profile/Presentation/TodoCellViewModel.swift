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
        todo.id
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
        guard let description = todo.description else { return true }
        return description.isEmpty
    }

    func addNewTodoItem() {
        delegate?.todoCellViewModelDidReturnTitle(self)
    }

    func endEditingTitle(with title: String?) {
        delegate?.todoCellViewModel(self, didEndEditingWith: title)
    }
    
    func navigateToDetail() {
        delegate?.todoCellViewModelNavigateToDetail(self)
    }
}

protocol TodoCellViewModelDelegate: AnyObject {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem: Todo)
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel)
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?)
    func todoCellViewModelNavigateToDetail(_ viewModel: TodoCellViewModel)
}
