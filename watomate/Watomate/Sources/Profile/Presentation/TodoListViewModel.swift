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
        case viewDidAppear(_ vc: TodoTableViewController)
    }
    
    enum Output {
        case loadFailed(errorMessage: String)
    }
    
    private var isCalling: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    private var viewModelsSubject = CurrentValueSubject<[Int: [TodoCellViewModel]], Never>([:]) //Int는 section index
    var vms: AnyPublisher<[Int: [TodoCellViewModel]], Never> {
        return viewModelsSubject.eraseToAnyPublisher()
    }

    weak var delegate: (any TodoListViewModelDelegate)?
    private let todoUseCase: TodoUseCase

    var sectionsForGoalId = [Int: Int]() // [GoalId: Section index]
    var goalIdsForSections = [Int: Int]() // [Section index: GoalId]

    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear(let vc):
                if vc.isKind(of: HomeViewController.self) {
                    self?.loadTodos(on: Utils.YYYYMMddFormatter().string(from: Date()))
                } else {
                    self?.loadAllTodos()
                }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func updateViewModels(with goals: [Goal]) {
        sectionsForGoalId = [:]
        goalIdsForSections = [:]
        var curVMs = viewModelsSubject.value
        var cellVM: TodoCellViewModel
        var cellVMs: [TodoCellViewModel]
        var goal: Goal
        var section: Int
        for i in 0..<goals.count {
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
    }
    
    func loadAllTodos() {
        guard !isCalling else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let goals = try await todoUseCase.getAllTodos()
                updateViewModels(with: goals)
            } catch {
                self.output.send(.loadFailed(errorMessage: error.localizedDescription))
            }
        }
    }
    
    func loadTodos(on date: String) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let goals = try await todoUseCase.getTodos(on: date)
                updateViewModels(with: goals)
            } catch {
                self.output.send(.loadFailed(errorMessage: error.localizedDescription))
            }
        }
    }
    
    func addTodo(at indexPath: IndexPath, with todo: Todo) {
        Task {
            guard let goalId = goalIdsForSections[indexPath.section] else { return }
            let addedTodo = try await todoUseCase.addTodo(goalId, todo)
            guard let viewModel = viewModel(at: indexPath) else { return }
            viewModel.id = addedTodo.id
        }
    }

    func indexPath(with uuid: UUID) -> IndexPath? {
        var section: Int
        for set in self.viewModelsSubject.value {
            section = set.key
            let viewModels = set.value
            if let row = viewModels.firstIndex(where: { cellViewModel in
                cellViewModel.uuid == uuid
            }) {
                return .init(row: row, section: section)
            }
        }
        return nil
    }
    
    func todo(at indexPath: IndexPath) -> Todo? {
        guard let viewModel = viewModel(at: indexPath) else { return nil }
        guard let goal = goal(at: indexPath.section) else { return nil }
        return Todo(uuid: viewModel.uuid, id: viewModel.id, title: viewModel.title, color: goal.color, isCompleted: viewModel.isCompleted, goal: viewModel.goal, likes: viewModel.likes)
    }
    
    func goal(at section: Int) -> Goal? {
        return todoUseCase.goals[section - 1]
    }

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
        let newViewModel = {
            if let viewModel = viewModel(with: todo) {
                return viewModel
            }
            let newViewModel = TodoCellViewModel(todo: todo)
            newViewModel.delegate = self
            newViewModel.newlyAdded = true
            var curVMs = viewModelsSubject.value
            curVMs[indexPath.section]?.append(newViewModel)
            viewModelsSubject.send(curVMs)
            return newViewModel
        }()
        delegate?.todoListViewModel(self, didInsertCellViewModel: newViewModel, at: indexPath)
    }
    
    func remove(at indexPath: IndexPath) {
        guard let viewModel = viewModel(at: indexPath) else { return }
        var curVMs = viewModelsSubject.value
        curVMs[indexPath.section]?.remove(at: indexPath.row)
        viewModelsSubject.send(curVMs)
        
        if !viewModel.title.isEmpty {
            guard let goalId = goalIdsForSections[indexPath.section] else { return }
            guard let todoId = viewModel.id else { return }
            Task {
                try await todoUseCase.deleteTodo(goalId, todoId)
            }
        }
    }
    
    func section(with todo: Todo) -> Int? {
        if todoUseCase.goals.count == 0 {
            return nil
        }
        for i in 0..<todoUseCase.goals.count {
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
    
    func getTitle(of section: Int) -> String {
        if section == 0 {
            return ""
        } else {
            return todoUseCase.goals[section - 1].title
        }
    }
    
    func getColor(of section: Int) -> Color {
        let colorString = todoUseCase.goals[section - 1].color
        guard let color = Color(rawValue: colorString) else { return .system }
        return color
    }
    
    func getVisibility(of section: Int) -> Visibility {
        return todoUseCase.goals[section - 1].visibility
    }
}

extension TodoListViewModel {
    func appendPlaceholderIfNeeded(at section: Int) -> Bool {
        guard let goal = goal(at: section) else { return false }
        if todoUseCase.goals[section - 1].todos.count == 0 {
            append(.placeholderItem(with: goal))
            return true
        }
        guard let lastItem = todoUseCase.goals[section - 1].todos.last else { return false }
        if !lastItem.title.isEmpty {
            append(.placeholderItem(with: goal))
            return true
        }
        return false
    }
}

extension TodoListViewModel: TodoCellViewModelDelegate {
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didEndEditingTitleWith title: String?) {
        guard let indexPath = indexPath(with: viewModel.uuid) else { return }
        guard let todo = todo(at: indexPath) else { return }
        if title == nil || title?.isEmpty == true {
            remove(at: indexPath)
        } else if !viewModel.newlyAdded {
            Task {
                try await todoUseCase.updateTodo(todo)
            }
        } else {
            addTodo(at: indexPath, with: todo)
        }
    }
    
    func todoCellViewModelDidReturnTitle(_ viewModel: TodoCellViewModel) {
        guard let section = sectionsForGoalId[viewModel.goal] else { return }
        if viewModel.newlyAdded {
            appendPlaceholderIfNeeded(at: section)
        }
    }
    
    func todoCellViewModel(_ viewModel: TodoCellViewModel, didUpdateItem todo: Todo) {
        viewModelsSubject.send(viewModelsSubject.value)
        Task {
            try await todoUseCase.updateTodo(todo)
        }
    }

    func todoCellViewModelNavigateToDetail(_ cellViewModel: TodoCellViewModel) {
        delegate?.todoListViewModel(self, showDetailViewWith: cellViewModel)
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
    func todoListViewModel(_ viewModel: TodoListViewModel, showDetailViewWith cellViewModel: TodoCellViewModel)
}
