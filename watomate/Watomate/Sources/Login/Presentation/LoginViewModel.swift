//
//  LoginViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

final class LoginViewModel: ViewModelType {
    enum Input {
        case emailEdited(email: String)
        case passwordEdited(password: String)
        case okButtonTapped
    }
    
    enum Output {
        case loginFailed(errorMessage: String)
        case loginSucceed
        case toggleOkButton(isEnabled: Bool)
    }
    
    private let authUseCase: AuthUseCase
    
    private var email: String = ""
    private var password: String = ""
    private var isCalling: Bool = false

    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .emailEdited(let email):
                self.email = email
                self.isButtonEnabled()
            case .passwordEdited(let password):
                self.password = password
                self.isButtonEnabled()
            case .okButtonTapped:
                self.login()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func isButtonEnabled() {
        let isEnabled = email.isEmail && password.count > 3
        output.send(.toggleOkButton(isEnabled: isEnabled))
    }
    
    func login() {
        guard !isCalling else { return }
        isCalling = true
        
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.authUseCase.loginWithEmail(email: self.email, password: self.password)
                self.output.send(.loginSucceed)
                self.isCalling = false
            } catch {
                self.output.send(.loginFailed(errorMessage: error.localizedDescription))
                self.isCalling = false
            }
            
        }
    }
}

