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
    case getAllUsers
    case getDiaryFeed(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getAllUsers:
            return .get
        case .getDiaryFeed:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "/user-all"
        case let .getDiaryFeed(id):
            return "\(id)/diaryfeed"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllUsers:
            return [:]
        case let .getDiaryFeed(id):
            return [:]
        }
    }
}
