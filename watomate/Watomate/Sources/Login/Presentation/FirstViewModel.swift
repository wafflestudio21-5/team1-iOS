//
//  FirstViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

final class FirstViewModel: ViewModelType {
    enum Input {
        case kakaoLoginTapped
        case guestLoginTapped
    }
    
    enum Output {
        case kakaoLoginSuceed
        case kakaoLoginFailed(errorMessage: String)
        case guestLoginSuceed
        case guestLoginFailed(errorMessage: String)
    }
    
    private var authUseCase: AuthUseCase
    private var isCalling: Bool = false
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .kakaoLoginTapped:
                self?.kakaoLogin()
            case .guestLoginTapped:
                self?.guestLogin()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func kakaoLogin() {
        guard !isCalling else { return }
        isCalling = true
        
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.authUseCase.loginWithKakao()
                self.output.send(.kakaoLoginSuceed)
                self.isCalling = false
            } catch {
                self.output.send(.kakaoLoginFailed(errorMessage: error.localizedDescription))
                self.isCalling = false
            }
            
        }
    }
    
    private func guestLogin() {
        guard !isCalling else { return }
        isCalling = true
        
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.authUseCase.signupGuest()
                self.output.send(.guestLoginSuceed)
                self.isCalling = false
            } catch {
                self.output.send(.guestLoginFailed(errorMessage: error.localizedDescription))
                self.isCalling = false
            }
            
        }
    }
}
