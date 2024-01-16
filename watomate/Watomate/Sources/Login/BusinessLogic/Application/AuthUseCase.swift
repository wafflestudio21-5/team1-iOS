//
//  AuthUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class AuthUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol, userDefaultsRepository: UserDefaultsRepositoryProtocol) {
        self.authRepository = authRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func signupWithEmail(email: String, password: String) async throws -> LoginInfo {
        return try await authRepository.signupWithEmail(email: email, password: password)
    }
    
    func saveLoginInfo(loginInfo: LoginInfo) {
        userDefaultsRepository.set(String.self, key: .accessToken, value: loginInfo.token)
        userDefaultsRepository.set(Int.self, key: .userId, value: loginInfo.id)
        userDefaultsRepository.set(Bool.self , key: .isLoggedIn, value: true)
    }
    
}
