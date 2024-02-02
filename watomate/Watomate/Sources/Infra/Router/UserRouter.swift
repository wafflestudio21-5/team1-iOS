//
//  UserRouter.swift
//  Watomate
//
//  Created by 이지현 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum UserRouter: Router {
    case changeProfilePic(id: Int)
    case changeUserInfo(id: Int)
    case getAllImage
    
    var method: HTTPMethod {
        switch self {
        case .changeProfilePic, .changeUserInfo:
            return .patch
        case .getAllImage:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .changeProfilePic(id):
            return "/\(id)"
        case let .changeUserInfo(id):
            return "/\(id)"
        case let .getAllImage:
            return "/image-all"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .changeProfilePic:
            return [:]
        case .changeUserInfo:
            return [:]
        case .getAllImage:
            return [:]
        }
    }
}
