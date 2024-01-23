//
//  SearchRouter.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum SearchRouter: Router {
    case getUserInfo(id: Int)
    case getAllUsers
    case getDiaryFeed(id: Int)
    case searchUser(username: String)
    case getTodoFeed
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        case .getAllUsers:
            return .get
        case .getDiaryFeed:
            return .get
        case .searchUser:
            return .get
        case .getTodoFeed:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .getUserInfo(id):
            return "/\(id)"
        case .getAllUsers:
            return "/user-all"
        case let .getDiaryFeed(id):
            return "\(id)/diaryfeed"
        case .searchUser:
            return "/user-search"
        case .getTodoFeed:
            return "/todofeed"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserInfo:
            return [:]
        case .getAllUsers:
            return [:]
        case .getDiaryFeed:
            return [:]
        case let .searchUser(user):
            return ["username": user]
        case .getTodoFeed:
            return [:]
        }
    }
}
