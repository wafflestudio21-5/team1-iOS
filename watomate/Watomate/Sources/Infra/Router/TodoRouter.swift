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
    case getTodos(userId: Int, date: String)
    case addTodo(userId: Int, goalId: Int, todo: Todo)
    case deleteTodo(userId: Int, goalId: Int, todoId: Int)
    case updateTodo(userId: Int, todoId: Int, todo: Todo)
//    case getGoalData(userId: Int, goalId: Int)
//    case addGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case updateGoal(userId: Int, goalId: Int, goal: GoalDto)
//    case deleteGoal(userId: Int, goalId: Int)

    var method: HTTPMethod {
        switch self {
        case .getAllTodos:
            return .get
        case .getTodos:
            return .get
        case .addTodo:
            return .post
        case .deleteTodo:
            return .delete
        case .updateTodo:
            return .patch
        }
    }
    
    var path: String {
        switch self {
        case let .getAllTodos(userId):
            return "/\(userId)/goals"
        case let .getTodos(userId, _):
            return "/\(userId)/goals"
        case let .addTodo(userId, goalId, _):
            return "/\(userId)/goals/\(goalId)/todos"
        case let .deleteTodo(userId, goalId, todoId):
            return "/\(userId)/goals/\(goalId)/todos/\(todoId)"
        case let .updateTodo(userId, todoId, todo):
            return "/\(userId)/goals/\(todo.goal)/todos/\(todoId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllTodos:
            return nil
        case let .getTodos(_, date):
            return ["date": date]
        case let .addTodo(_, _, todo):
            return ["title": todo.title, "date": todo.date, "is_completed": false]
        case .deleteTodo:
            return nil
        case let .updateTodo(_, _, todo):
            return ["title": todo.title,
                    "description": todo.description ?? "",
                    "reminder": todo.reminder,
                    "date": todo.date,
                    "is_completed": todo.isCompleted
                    ]
        }
    }
}
