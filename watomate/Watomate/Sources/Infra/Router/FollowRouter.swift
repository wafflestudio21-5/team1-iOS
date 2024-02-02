//
//  FollowRouter.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum FollowRouter: Router {
    case getFollowInfo(userId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getFollowInfo:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .getFollowInfo(userId):
            return "/\(userId)/follows"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getFollowInfo:
            return nil
        }
    }
}
