//
//  JoinViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Alamofire

class JoinViewModel {
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    var email: String = ""
    var password: String = ""
    var isChecked: Bool = false
    
    private var isCalling: Bool = false
    
    var isEmailValid: Bool {
        email.isEmail
    }
    
    var isPasswordValid: Bool {
        password.count > 3
    }
    
    var canSubmit: Bool {
        isEmailValid && isPasswordValid && isChecked
    }

    func signUp() -> Bool {
        guard canSubmit && !isCalling else { return false }
        isCalling = true
        
        let param: Parameters = [
            "email": email,
            "password": password
        ]
        
        let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/login/email"
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON {[weak self] data in
            self?.isCalling = false
            print(data)
        }
        return false 
    }
    
//    func signUp() async -> Bool {
//        guard canSubmit && !isCalling else { return false }
//        isCalling = true
//        
//        do {
//            try await authUseCase.registerWithEmail(email: email, password: password)
//            isCalling = false
//            return true
//        } catch {
//            print(error)
//            isCalling = false
//            return false
//        }
//        
//    }
}
