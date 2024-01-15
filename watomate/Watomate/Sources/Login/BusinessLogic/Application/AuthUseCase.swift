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
    
}
