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
    case followUser(user_to_follow: Int)
    case unfollowUser(user_to_unfollow: Int)
    case removeUser(userId: Int, user_to_remove: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getFollowInfo:
            return .get
        case .followUser:
            return .put
        case .unfollowUser:
            return .put
        case .removeUser:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case let .getFollowInfo(userId):
            return "/\(userId)/follows"
        case let .followUser(user_to_follow):
            return "/follow"
        case let .unfollowUser(user_to_unfollow):
            return "/unfollow"
        case let .removeUser(userId, user_to_remove):
            return "/\(userId)/follows"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getFollowInfo:
            return nil
        case let .followUser(user_to_follow):
            return ["user_to_follow" : user_to_follow]
        case let .unfollowUser(user_to_unfollow):
            return ["user_to_unfollow" : user_to_unfollow]
        case let .removeUser(_, user_to_remove):
            return ["user_to_remove" : user_to_remove]
        }
    }
    
}
