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
    
    
    func signUp() {
        guard canSubmit && !isCalling else { return }
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
        
    }
}
