//
//  InitialUserViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum InitialUserSection: CaseIterable {
    case main
}

final class InitialUserViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateUserList(userList: [UserCellViewModel])
    }
    
    private var searchUseCase: SearchUseCase
    private var userList = [UserCellViewModel]()
    var isFetching: Bool = false
    var canFetchMoreUsers: Bool = true
    var nextUrl: String? = nil
    
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
            guard let usersPage = try? await searchUseCase.getInitialUsers() else {
                isFetching = false
                return
            }
            nextUrl = usersPage.nextUrl
            if nextUrl == nil { canFetchMoreUsers = false }
            userList.append(contentsOf: usersPage.results.map{ UserCellViewModel(userInfo: $0) })
            output.send(.updateUserList(userList: userList))
            isFetching = false
            fetchMoreUsers()
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
