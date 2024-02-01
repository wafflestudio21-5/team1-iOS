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
    case getArchiveTodos(userId: Int)
    case getTodos(userId: Int, date: String)
    case addTodo(userId: Int, goalId: Int, todo: Todo)
    case deleteTodo(userId: Int, goalId: Int, todoId: Int)
    case updateTodo(userId: Int, todoId: Int, todo: Todo)
//    case getGoalData(userId: Int, goalId: Int)
    case addGoal(userId: Int, goal: GoalCreate)
    case patchGoal(userId: Int, goalId: Int, goal: GoalCreate)
    case deleteGoal(userId: Int, goalId: Int)

    var method: HTTPMethod {
        switch self {
        case .getAllTodos:
            return .get
        case .getArchiveTodos:
            return .get
        case .getTodos:
            return .get
        case .addTodo:
            return .post
        case .deleteTodo:
            return .delete
        case .updateTodo:
            return .patch
        case .addGoal:
            return .post
        case .patchGoal:
            return .patch
        case .deleteGoal:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case let .getAllTodos(userId):
            return "/\(userId)/goals"
        case let .getArchiveTodos(userId):
            return "/\(userId)/goals"
        case let .getTodos(userId, _):
            return "/\(userId)/goals"
        case let .addTodo(userId, goalId, _):
            return "/\(userId)/goals/\(goalId)/todos"
        case let .deleteTodo(userId, goalId, todoId):
            return "/\(userId)/goals/\(goalId)/todos/\(todoId)"
        case let .updateTodo(userId, todoId, todo):
            return "/\(userId)/goals/\(todo.goal)/todos/\(todoId)"
        case let .addGoal(userId, _):
            return "/\(userId)/goals"
        case let .patchGoal(userId, goalId, _):
            return "/\(userId)/goals/\(goalId)"
        case let .deleteGoal(userId, goalId):
            return "/\(userId)/goals/\(goalId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllTodos:
            return nil
        case .getArchiveTodos:
            return ["date": "null"]
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
        case let .addGoal(_, goal):
            return ["title": goal.title, "visibility" : goal.visibility, "color" : goal.color]
        case let .patchGoal(_, _, goal):
            return ["title": goal.title, "visibility" : goal.visibility, "color" : goal.color]
        case .deleteGoal:
            return nil
        }
    }
}
