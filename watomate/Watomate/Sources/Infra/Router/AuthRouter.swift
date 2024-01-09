//
//  AuthRouter.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum AuthRouter: Router {
    case registerWithEmail(email: String, password: String)
    
    var method: HTTPMethod {
        switch self {
        case .registerWithEmail:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .registerWithEmail:
            return "/login/email"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .registerWithEmail(email, password):
            return ["email": email, "password": password]
        }
    }
}
