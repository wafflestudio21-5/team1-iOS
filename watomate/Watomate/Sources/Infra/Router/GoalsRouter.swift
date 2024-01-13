//
//  GoalsRouter.swift
//  Watomate
//
//  Created by 권현구 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum GoalsRouter: Router {
    case getAllTodos(userId: Int)
    //
//    case getGoalData(userId: Int, goalId: Int)
//    case addGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case updateGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case addTodo(userId: Int, todo: TodoDto)
//    case deleteGoal(userId: Int, goalId: Int)
//    case get
//    case deleteTodo(userId: Int, )
    
    var method: HTTPMethod {
        switch self {
        case .getAllTodos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .getAllTodos(userId):
            return "/\(userId)/goals"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllTodos:
            return nil
        }
    }
}
