//
//  ProfileViewControllerViewModel.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class ProfileViewControllerViewModel {
    weak var delegate: (any ProfileViewControllerViewModelDelegate)?
    private let todoUseCase: TodoUseCase

    var sectionsForGoalId = [Int: Int]() // GoalId: Section index
    var viewModels = [Int: TodoCellViewModel]() //Int : todoId에 해당
    
    func getAllTodos() async {//-> [TodoCellViewModel]{
        guard let goals = try? await todoUseCase.getTodos(with: 1) else { return }
        var viewModels = [TodoCellViewModel]()
        var indexPaths = [IndexPath]()
        let todos = goals.flatMap { goal in
            goal.todos
        }
        for goal in goals {
            for todo in goal.todos {
                let viewModel = TodoCellViewModel(todo: todo)
                let section = (sectionsForGoalId[todo.goal] ?? sectionsForGoalId.count) + 1
                self.viewModels[todo.id] = viewModel
                viewModels.append(viewModel)
                
                let indexPath = IndexPath.init(row: viewModels.filter({ model in
                    model.goal == goal.id
                }).count - 1, section: section)
                indexPaths.append(indexPath)
            }
            sectionsForGoalId[goal.id] = sectionsForGoalId.count
        }
//        self.viewModels = viewModels
    }
    
    init(repository: some TodoItemRepositoryProtocol) {
        self.todoUseCase = TodoUseCase(todoRepository: repository)
    }

    private func todo(at indexPath: IndexPath) -> Todo? {
        let goal = todoUseCase.goals[safe: indexPath.section - 1]
        let todo = goal?.todos[safe: indexPath.row]
        return todo
    }

    func viewModel(at indexPath: IndexPath) -> TodoCellViewModel? {
        guard let item = todo(at: indexPath) else { return nil }
        return viewModel(with: item)
    }

    func viewModel(with todo: Todo) -> TodoCellViewModel? {
        if let viewModel = viewModels[todo.id] {
            return viewModel
        }
        return nil
    }

    func numberOfRowsInSection(section: Int) -> Int {
        let goal = todoUseCase.goals[safe: section]
        guard let numRows = goal?.todos.count else { return 0 }
        return numRows
    }

    func insert(_ todo: Todo, at indexPath: IndexPath) {
//        todoRepository.insert(todo, at: indexPath)
        let newViewModel = {
            if let viewModel = viewModel(with: todo) {
                return viewModel
            }
            let newViewModel = TodoCellViewModel(todo: todo)
            viewModels[newViewModel.id] = newViewModel
            return newViewModel
        }()

        delegate?.profileViewControllerViewModel(self, didInsertTodoViewModel: newViewModel, at: indexPath)
    }
    
    func section(with todo: Todo) -> Int? {
        if todoUseCase.goals.count == 0 {
            return nil
        }
        for i in 0...todoUseCase.goals.count - 1 {
            if todoUseCase.goals[i].id == todo.goal {
                return i
            }
        }
        return nil
    }

    func append(_ todo: Todo) {
        let section = section(with: todo)
        if section == nil {
            return
        }
        insert(todo, at: .init(row: todoUseCase.goals[section!].todos.count, section: section!))
    }

    func remove(at indexPath: IndexPath) {
        guard let todoItem = todo(at: indexPath), let viewModel = viewModel(with: todoItem) else { return }
//        todoRepository.remove(todoItem)
        viewModels.removeValue(forKey: todoItem.id)
        delegate?.profileViewControllerViewModel(self, didRemoveTodoViewModel: viewModel, at: indexPath, options: [.reload])
    }
    
    func getTitle(of section: Int) -> String {
        if section == 0 {
            return ""
        } else {
            return todoUseCase.goals[section - 1].title
        }
    }
}

extension ProfileViewControllerViewModel {
//    func appendPlaceholderIfNeeded(at section: Int) -> Bool {
//        if numberOfRowsInSection(section: section) == 0 {
//            append(.placeholderItem())
//            return true
//        }
//
//        guard let lastItem = todoRepository.get(at: .init(row: numberOfItems - 1, section: 0)) else { return false }
//        if !lastItem.title.isEmpty {
//            append(.placeholderItem())
//            return true
//        }
//
//        return false
//    }
}

extension ProfileViewControllerViewModel: TodoCellViewModelDelegate {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?) {
//        if title == nil || title?.isEmpty == true {
//            guard let indexPath = todoRepository.indexPath(with: viewModel.id) else { return }
//            remove(at: indexPath)
//        }
    }
    
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel) {
//        appendPlaceholderIfNeeded()
    }
    
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem todo: Todo) {
//        guard let indexPath = todoRepository.indexPath(with: viewModel.id) else { return }
//        todoRepository.update(todo)
    }

}


struct ReloadOptions: OptionSet {
    let rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static let reload = ReloadOptions(rawValue: 1 << 1)
    static let animated = ReloadOptions(rawValue: 1 << 2)
}

protocol ProfileViewControllerViewModelDelegate: AnyObject {
    func profileViewControllerViewModel(
        _ viewModel: ProfileViewControllerViewModel,
        didInsertTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath
    )

    func profileViewControllerViewModel(
        _ viewModel: ProfileViewControllerViewModel,
        didRemoveTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath,
        options: ReloadOptions
    )
    
    func profileViewControllerViewModel(_ viewModel: ProfileViewControllerViewModel, didInsertTodoViewModels newViewModels: [TodoCellViewModel], at indexPaths: [IndexPath])
}
