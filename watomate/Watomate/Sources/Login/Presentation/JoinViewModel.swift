//
//  JoinViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

final class JoinViewModel: ViewModelType {
    enum Input {
        case emailEdited(email: String)
        case passwordEdited(password: String)
        case checkButtonTapped
        case okButtonTapped
    }
    
    enum Output {
        case signupFailed(errorMessage: String)
        case signupSucceed
        case guestSignUpSucceed
        case toggleCheckButton(isChecked: Bool)
        case toggleOkButton(isEnabled: Bool)
    }
    
    private let authUseCase: AuthUseCase
    
    private var email: String = ""
    private var password: String = ""
    private var isChecked: Bool = false
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
            case .checkButtonTapped:
                self.isChecked.toggle()
                self.output.send(.toggleCheckButton(isChecked: self.isChecked))
                self.isButtonEnabled()
            case .okButtonTapped:
                self.signup()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func isButtonEnabled() {
        let isEnabled = email.isEmail && password.count > 3 && isChecked
        output.send(.toggleOkButton(isEnabled: isEnabled))
    }
    
    func signup() {
        guard !isCalling else { return }
        isCalling = true
        
        Task { [weak self] in
            guard let self else { return }
            do {
                if let loginMethod = User.shared.loginMethod,
                   loginMethod == .guest {
                    try await self.authUseCase.guestLogin(email: self.email, password: self.password)
                    self.output.send(.guestSignUpSucceed)
                } else {
                    try await self.authUseCase.signupWithEmail(email: self.email, password: self.password)
                    self.output.send(.signupSucceed)
                }
                self.isCalling = false
            } catch {
                self.output.send(.signupFailed(errorMessage: error.localizedDescription))
                self.isCalling = false
            }
            
        }
    }
}

