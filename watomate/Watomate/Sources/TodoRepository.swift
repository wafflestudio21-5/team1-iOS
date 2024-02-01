//
//  TodoItemRepository.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

class TodoRepository: TodoRepositoryProtocol {

    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
    }

    func getAllTodos() async throws -> GoalsResponseDto {
        let response = try await session
            .request(TodoRouter.getAllTodos(userId: User.shared.id!))
            .serializingDecodable(GoalsResponseDto.self)
            .handlingError()
        return response
    }
    
    func getArchiveTodos() async throws -> GoalsResponseDto {
        let response = try await session
            .request(TodoRouter.getArchiveTodos(userId: User.shared.id!))
            .serializingDecodable(GoalsResponseDto.self)
            .handlingError()
        return response
    }
    
    func getTodos(on date: String) async throws -> GoalsResponseDto {
        let response = try await session
            .request(TodoRouter.getTodos(userId: User.shared.id!, date: date))
            .serializingDecodable(GoalsResponseDto.self)
            .handlingError()
        return response
    }
    
    func addTodo(goalId: Int, todo: Todo) async throws -> TodoDto {
        let response = try await session
            .request(TodoRouter.addTodo(userId: User.shared.id!, goalId: goalId, todo: todo))
            .serializingDecodable(TodoDto.self)
            .handlingError()
        return response
    }
    
    func deleteTodo(goalId: Int, todoId: Int) async throws {
        let response = try await session
            .request(TodoRouter.deleteTodo(userId: User.shared.id!, goalId: goalId, todoId: todoId))
            .serializingString()
            .handlingError()
    }

    func updateTodo(todo: Todo) async throws -> TodoDto? {
        guard let todoId = todo.id else { return nil }
        let response = try await session
            .request(TodoRouter.updateTodo(userId: User.shared.id!, todoId: todoId, todo: todo))
            .serializingDecodable(TodoDto.self)
            .handlingError()
        print("updated: \(response)")
        return response
    }
}
