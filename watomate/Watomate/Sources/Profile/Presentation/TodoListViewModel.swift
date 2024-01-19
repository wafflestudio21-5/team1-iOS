//
//  ProfileViewControllerViewModel.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Combine

class TodoListViewModel: ViewModelType {
    enum Input {
        case viewDidAppear
//        case todoInserted(viewModel: TodoCellViewModel)
//        case todoDeleted
//        case todoEdited
    }
    
    enum Output {
        case loadFailed(errorMessage: String)
//        case insertFailed(errorMessage: String)
//        case deleteFailed(errorMessage: String)
//        case editFailed(errorMessage: String)
        case loadSucceed(goals: [Goal])
//        case inserSucceed
//        case deleteSucceed
//        case editSucceed
    }
    
    private var isCalling: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()

    weak var delegate: (any TodoListViewModelDelegate)?
    private let todoUseCase: TodoUseCase

    var sectionsForGoalId = [Int: Int]() // GoalId: Section index
    var goalIdsForSections = [Int: Int]() // Section index: GoalId
    var viewModels = [Int: [TodoCellViewModel]]() //Int : section index에 해당

    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.loadTodos()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func loadTodos() {
        guard !isCalling else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let goals = try await todoUseCase.getAllTodos(userId: 1)
                var cellVM: TodoCellViewModel
                var cellVMs: [TodoCellViewModel]
                var goal: Goal
                var section: Int
                for i in 0...goals.count - 1 {
                    section = i + 1
                    goal = goals[i]
                    sectionsForGoalId[goal.id] = sectionsForGoalId.count + 1
                    goalIdsForSections[sectionsForGoalId.count] = goal.id
                    cellVMs = []
                    for todo in goal.todos {
                        cellVM = TodoCellViewModel(todo: todo)
                        cellVMs.append(cellVM)
                    }
                    self.viewModels[section] = cellVMs
                }
                self.output.send(.loadSucceed(goals: goals))
            } catch {
                self.output.send(.loadFailed(errorMessage: error.localizedDescription))
            }
        }
    }
    
    func addTodo(todo: Todo) async {
        await todoUseCase.addTodo(userId: 1, goalId: 1, todo: todo)
    }

//    private func todo(at indexPath: IndexPath) -> Todo? {
//        let goal = todoUseCase.goals[safe: indexPath.section - 1]
//        let todo = goal?.todos[safe: indexPath.row]
//        return todo
//    }

    func viewModel(at indexPath: IndexPath) -> TodoCellViewModel? {
        guard let cellVMs = self.viewModels[indexPath.section] else { return nil }
        let viewModel = cellVMs[indexPath.row]
        return viewModel
    }

//    func viewModel(with todo: Todo) -> TodoCellViewModel? {
//        guard let todoId = todo.id else { return nil }
//        if let viewModel = viewModels[todoId] {
//            return viewModel
//        }
//        return nil
//    }

//    func numberOfRowsInSection(section: Int) -> Int {
//        let goal = todoUseCase.goals[safe: section]
//        guard let numRows = goal?.todos.count else { return 0 }
//        return numRows
//    }

//    func insert(_ todo: Todo, at indexPath: IndexPath) {
////        todoRepository.insert(todo, at: indexPath)
//        guard let todoId = todo.id else { return }
//        let newViewModel = {
//            if let viewModel = viewModel(with: todo) {
//                return viewModel
//            }
//            let newViewModel = TodoCellViewModel(todo: todo)
//            viewModels[todoId] = newViewModel
//            return newViewModel
//        }()
//
//        delegate?.profileViewControllerViewModel(self, didInsertTodoViewModel: newViewModel, at: indexPath)
//    }
    
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

//    func append(_ todo: Todo) {
//        let section = section(with: todo)
//        if section == nil {
//            return
//        }
//        insert(todo, at: .init(row: todoUseCase.goals[section!].todos.count, section: section!))
//    }

//    func remove(at indexPath: IndexPath) {
//        guard let todoItem = todo(at: indexPath), let viewModel = viewModel(with: todoItem) else { return }
////        todoRepository.remove(todoItem)
//        guard let todoId = todoItem.id else { return }
//        viewModels.removeValue(forKey: todoId)
//        delegate?.profileViewControllerViewModel(self, didRemoveTodoViewModel: viewModel, at: indexPath, options: [.reload])
//    }
    
    func getTitle(of section: Int) -> String {
        if section == 0 {
            return ""
        } else {
            return todoUseCase.goals[section - 1].title
        }
    }
}

extension TodoListViewModel {
//    func appendPlaceholderIfNeeded(at section: Int) -> Bool {
//        if numberOfRowsInSection(section: section) == 0 {
//            append(.placeholderItem(at: <#Int#>))
//            return true
//        }
//
//        guard let lastItem = todoUseCase.get(at: .init(row: numberOfRowsInSection(section: section) - 1, section: section)) else { return false }
//        if !lastItem.title.isEmpty {
//            append(.placeholderItem(at: <#Int#>))
//            return true
//        }
//
//        return false
//    }
}

extension TodoListViewModel: TodoCellViewModelDelegate {
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

protocol TodoListViewModelDelegate: AnyObject {
    func profileViewControllerViewModel(
        _ viewModel: TodoListViewModel,
        didInsertTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath
    )

    func profileViewControllerViewModel(
        _ viewModel: TodoListViewModel,
        didRemoveTodoViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath,
        options: ReloadOptions
    )
    
    func profileViewControllerViewModel(_ viewModel: TodoListViewModel, didInsertTodoViewModels newViewModels: [TodoCellViewModel], at indexPaths: [IndexPath])
}
