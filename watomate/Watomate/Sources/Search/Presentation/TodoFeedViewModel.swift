//
//  TodoFeedViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum TodoFeedSection: CaseIterable {
    case main
}

final class TodoFeedViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateTodoList(todoList: [TodoUserCellViewModel])
    }
    
    var searchText: String?
    
    private var searchUseCase: SearchUseCase
    private var todoList = [TodoUserCellViewModel]()
    private var isFetching: Bool = false
    private var canFetchMoreTodo: Bool = true
    private var nextUrl: String? = nil
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
    }
    
    func viewModel(at indexPath: IndexPath) -> TodoUserCellViewModel {
        return todoList[indexPath.row]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                if let _ = self?.searchText {
                    self?.searchInitialTodo()
                } else {
                    self?.fetchInitialTodo()
                }
                self?.fetchInitialTodo()
            case .reachedEndOfScrollView:
                self?.fetchMoreTodo()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchInitialTodo() {
        if isFetching || !canFetchMoreTodo { return }
        isFetching = true
        Task {
            guard let todoPage = try? await searchUseCase.getTodoFeed() else {
                isFetching = false
                return
            }
            nextUrl = todoPage.nextUrl
            if nextUrl == nil { canFetchMoreTodo = false }
            todoList.append(contentsOf: todoPage.results.map{ TodoUserCellViewModel(todoUser: $0) })
            output.send(.updateTodoList(todoList: todoList))
            isFetching = false
        }
    }
    
    private func fetchMoreTodo() {
        if isFetching || !canFetchMoreTodo { return }
        isFetching = true
        Task {
            guard let todoPage = try? await searchUseCase.getMoreTodo(nextUrl: nextUrl!) else {
                isFetching = false
                return
            }
            nextUrl = todoPage.nextUrl
            if nextUrl == nil { canFetchMoreTodo = false }
            todoList.append(contentsOf: todoPage.results.map{ TodoUserCellViewModel(todoUser: $0) })
            output.send(.updateTodoList(todoList: todoList))
            isFetching = false
        }
    }
    
    private func searchInitialTodo() {
        if isFetching || !canFetchMoreTodo { return }
        isFetching = true
        Task {
            guard let searchText,
                  let todoPage = try? await searchUseCase.searchInitialTodo(title: searchText) else {
                isFetching = false
                return
            }
            nextUrl = todoPage.nextUrl
            if nextUrl == nil { canFetchMoreTodo = false }
            todoList.append(contentsOf: todoPage.results.map{ TodoUserCellViewModel(todoUser: $0) })
            output.send(.updateTodoList(todoList: todoList))
            isFetching = false
        }
    }
}
