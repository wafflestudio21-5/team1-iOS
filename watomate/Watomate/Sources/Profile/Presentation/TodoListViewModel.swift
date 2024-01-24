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
    }
    
    enum Output {
        case loadFailed(errorMessage: String)
    }
    
    private var isCalling: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    private var viewModelsSubject = CurrentValueSubject<[Int: [TodoCellViewModel]], Never>([:]) //Int : section index에 해당
    var vms: AnyPublisher<[Int: [TodoCellViewModel]], Never> {
        return viewModelsSubject.eraseToAnyPublisher()
    }

    weak var delegate: (any TodoListViewModelDelegate)?
    private let todoUseCase: TodoUseCase

    var sectionsForGoalId = [Int: Int]() // GoalId: Section index
    var goalIdsForSections = [Int: Int]() // Section index: GoalId

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
                var curVMs = viewModelsSubject.value
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
                        cellVM.delegate = self
                        cellVMs.append(cellVM)
                    }
                    curVMs[section] = cellVMs
                }
                viewModelsSubject.send(curVMs)
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
        guard let cellVMs = self.viewModelsSubject.value[indexPath.section] else { return nil }
        let viewModel = cellVMs[indexPath.row]
        return viewModel
    }

    func viewModel(with todo: Todo) -> TodoCellViewModel? {
        let goalId = todo.goal
        guard let section = sectionsForGoalId[goalId] else { return nil }
        guard let cellVMs = self.viewModelsSubject.value[section] else { return nil }
        for vm in cellVMs {
            if vm.uuid == todo.uuid {
                return vm
            }
        }
        return nil
    }

    func insert(_ todo: Todo, at indexPath: IndexPath) {
//        todoUseCase.insert(todo, at: indexPath)
        let newViewModel = {
            if let viewModel = viewModel(with: todo) {
                return viewModel
            }
            let newViewModel = TodoCellViewModel(todo: todo)
            newViewModel.delegate = self
            var curVMs = viewModelsSubject.value
            curVMs[indexPath.section]?.append(newViewModel)
            viewModelsSubject.send(curVMs)
            return newViewModel
        }()
        
        delegate?.todoListViewModel(self, didInsertCellViewModel: newViewModel, at: indexPath)
    }
    
    func section(with todo: Todo) -> Int? {
        if todoUseCase.goals.count == 0 {
            return nil
        }
        for i in 0...todoUseCase.goals.count - 1 {
            if todoUseCase.goals[i].id == todo.goal {
                return i + 1
            }
        }
        return nil
    }

    func append(_ todo: Todo) {
        let section = section(with: todo)
        if section == nil {
            return
        }
        guard let row = viewModelsSubject.value[section!]?.count else { return }
        insert(todo, at: .init(row: row, section: section!))
    }

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
    func appendPlaceholderIfNeeded(at section: Int) -> Bool {
        guard let goalId = goalIdsForSections[section] else { return false }
        if viewModelsSubject.value[section]?.count == 0 {
            append(.placeholderItem(with: goalId))
            return true
        }
        guard let lastItem = viewModelsSubject.value[section]?.last else { return false }
        if !lastItem.title.isEmpty {
            append(.placeholderItem(with: goalId))
            return true
        }

        return false
    }
}

extension TodoListViewModel: TodoCellViewModelDelegate {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingWith title: String?) {
        if title == nil || title?.isEmpty == true {
//            guard let indexPath = todoRepository.indexPath(with: viewModel.id) else { return }
//            remove(at: indexPath)
        }
    }
    
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel) {
        guard let section = sectionsForGoalId[viewModel.goal] else { return }
        appendPlaceholderIfNeeded(at: section)
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
    func todoListViewModel(
        _ viewModel: TodoListViewModel,
        didInsertCellViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath
    )

    func todoListViewModel(
        _ viewModel: TodoListViewModel,
        didRemoveCellViewModel todoViewModel: TodoCellViewModel,
        at indexPath: IndexPath,
        options: ReloadOptions
    )
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didUpdateItem: Todo, at indexPath: IndexPath)
}
