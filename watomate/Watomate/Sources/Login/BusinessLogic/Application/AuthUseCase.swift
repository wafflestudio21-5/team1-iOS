//
//  AuthUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
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
    
    func registerWithEmail(email: String, password: String) async throws {
        let dto = try await authRepository.registerWithEmail(email: email, password: password)
        saveAccessTokenAndId(dto: dto)
    }
    
    private func saveAccessTokenAndId(dto: LoginResponseDto) {
        userDefaultsRepository.set(String.self, key: .accessToken, value: dto.token)
//        userDefaultsRepository.set(String.self, key: .userId, value: dto.userId)
    }
}
