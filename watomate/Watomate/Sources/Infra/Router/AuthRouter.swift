//
//  AuthRouter.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum AuthRouter: Router {
    case signupWithEmail(email: String, password: String)
    
    var method: HTTPMethod {
        switch self {
        case .signupWithEmail:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signupWithEmail:
            return "/signup/email"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .signupWithEmail(email, password):
            return ["email": email, "password": password]
        }
    }
}
