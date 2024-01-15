//
//  LoginViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    var email: String = ""
    var password: String = ""
    
    private var isCalling: Bool = false
    
    var isEmailValid: Bool {
        email.isEmail
    }
    
    var isPasswordValid: Bool {
        password.count > 3
    }
    
    var canSubmit: Bool {
        isEmailValid && isPasswordValid
    }
    
}
