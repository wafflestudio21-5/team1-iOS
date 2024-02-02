//
//  UserTodoViewModel.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class UserTodoViewModel: ViewModelType {
    
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case updateUserTodo
    }
    
    private let userInfo: TodoUserInfo
    
    init(userInfo: TodoUserInfo) {
        self.userInfo = userInfo
    }
    
    private let userUsecase = UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchUserTodo()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    var userTodos = [UserGoal]()
    
    var username: String {
        userInfo.username
    }
    
    var profilePic: String? {
        userInfo.profilePic
    }
    
    var intro: String? {
        userInfo.intro
    }
    
    func fetchUserTodo() {
        Task {
            do {
                let userTodos = try await userUsecase.getUserTodo(id: userInfo.id)
                self.userTodos = userTodos
                output.send(.updateUserTodo)
            }
        }
    }
    
}
