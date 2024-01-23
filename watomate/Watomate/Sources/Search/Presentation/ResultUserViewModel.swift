//
//  ResultUserViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum ResultUserSection: CaseIterable {
    case main
}

final class ResultUserViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateUserList(userList: [UserCellViewModel])
    }
    
    var searchText: String?
    
    private var searchUseCase: SearchUseCase
    private var userList = [UserCellViewModel]()
    private var isFetching: Bool = false
    private var canFetchMoreUsers: Bool = true
    private var nextUrl: String? = nil
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
    }
    
    func viewModel(at indexPath: IndexPath) -> UserCellViewModel {
        return userList[indexPath.row]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchInitialUsers()
            case .reachedEndOfScrollView:
                self?.fetchMoreUsers()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchInitialUsers() {
        if isFetching || !canFetchMoreUsers { return }
        isFetching = true
        Task {
            guard let searchText,
                  let usersPage = try? await searchUseCase.searchInitialUsers(username: searchText) else {
                isFetching = false
                return
            }
            nextUrl = usersPage.nextUrl
            if nextUrl == nil { canFetchMoreUsers = false }
            userList.append(contentsOf: usersPage.results.map{ UserCellViewModel(userInfo: $0) })
            output.send(.updateUserList(userList: userList))
            isFetching = false
        }
    }
    
    private func fetchMoreUsers() {
        if isFetching || !canFetchMoreUsers { return }
        isFetching = true
        Task {
            guard let usersPage = try? await searchUseCase.getMoreUsers(nextUrl: nextUrl!) else {
                isFetching = false
                return
            }
            nextUrl = usersPage.nextUrl
            if nextUrl == nil { canFetchMoreUsers = false }
            userList.append(contentsOf: usersPage.results.map{ UserCellViewModel(userInfo: $0) })
            output.send(.updateUserList(userList: userList))
            isFetching = false
        }
    }
    
}