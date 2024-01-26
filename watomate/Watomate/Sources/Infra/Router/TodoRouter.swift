//
//  GoalsRouter.swift
//  Watomate
//
//  Created by 권현구 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum TodoRouter: Router {
    case getAllTodos(userId: Int)
    case addTodo(userId: Int, goalId: Int, todo: Todo)
//    case getGoalData(userId: Int, goalId: Int)
//    case addGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case updateGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case deleteGoal(userId: Int, goalId: Int)
//    case get
//    case deleteTodo(userId: Int, )
    
    var method: HTTPMethod {
        switch self {
        case .getAllTodos:
            return .get
        case .addTodo:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .getAllTodos(userId):
            return "/\(userId)/goals"
        case let .addTodo(userId, goalId, _):
            return "/\(userId)/goals/\(goalId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllTodos:
            return nil
        case let .addTodo(_, _, todo):
            return ["title": todo.title, "date": "", "is_completed": false]
        }
    }
}
