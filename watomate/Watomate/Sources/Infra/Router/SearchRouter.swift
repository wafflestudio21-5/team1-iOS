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
    case getUserGoals(id: Int)
    case getAllUsers
    case getDiaryFeed(id: Int)
    case getTodoFeed
    case searchUser(username: String)
    case searchTodo(title: String)
    case likeDiary(diaryId: Int, user: Int, emoji: String)
    case commentDiary(diaryId: Int, userId: Int, description: String)
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        case .getUserGoals:
            return .get
        case .getAllUsers:
            return .get
        case .getDiaryFeed:
            return .get
        case .searchUser:
            return .get
        case .getTodoFeed:
            return .get
        case .searchTodo:
            return .get
        case .likeDiary:
            return .put
        case .commentDiary:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .getUserInfo(id):
            return "/\(id)"
        case let .getUserGoals(id):
            return "/\(id)/goals"
        case .getAllUsers:
            return "/user-all"
        case let .getDiaryFeed(id):
            return "\(id)/diaryfeed"
        case .searchUser:
            return "/user-search"
        case .getTodoFeed:
            return "/todofeed"
        case .searchTodo:
            return "todo-search"
        case let .likeDiary(diaryId, _, _):
            return "/diarys/\(diaryId)/like"
        case let .commentDiary(diaryId, _, _):
            return "/diarys/\(diaryId)/comment"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserInfo:
            return [:]
        case .getUserGoals:
            return [:]
        case .getAllUsers:
            return [:]
        case .getDiaryFeed:
            return [:]
        case let .searchUser(user):
            return ["username": user]
        case .getTodoFeed:
            return [:]
        case let .searchTodo(title):
            return ["title": title]
        case let .likeDiary(_, user, emoji):
            return ["user": user, "emoji": emoji]
        case let .commentDiary(_, userId, description):
            return ["user": userId, "description": description]
        }
    }
}
