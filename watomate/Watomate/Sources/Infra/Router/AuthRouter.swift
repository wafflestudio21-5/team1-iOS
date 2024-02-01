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
    case signupWithKakao(kakaoId: Int64)
    case signupGuest
    case loginWithEmail(email: String, password: String)
    case loginWithKakao(kakaoId: Int64)
    case deleteAccount
    
    var method: HTTPMethod {
        switch self {
        case .signupWithEmail:
            return .post
        case .signupWithKakao:
            return .post
        case .signupGuest:
            return .get
        case .loginWithEmail:
            return .post
        case .loginWithKakao:
            return .post
        case .deleteAccount:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .signupWithEmail:
            return "/signup/email"
        case .signupWithKakao:
            return "/signup/kakao"
        case .signupGuest:
            return "/signup/guest"
        case .loginWithEmail:
            return "/login/email"
        case .loginWithKakao:
            return "/login/kakao"
        case .deleteAccount:
            return "/\(User.shared.id!)/delete"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .signupWithEmail(email, password):
            return ["email": email, "password": password]
        case let .signupWithKakao(kakaoId):
            return ["kakao_id": kakaoId]
        case .signupGuest:
            return [:]
        case let .loginWithEmail(email, password):
            return ["email": email, "password": password]
        case let .loginWithKakao(kakaoId):
            return ["kakao_id": kakaoId]
        case .deleteAccount:
            return [:]
        }
    }
}
