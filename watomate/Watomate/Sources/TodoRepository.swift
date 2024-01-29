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

    private let session = Session(interceptor: Interceptor())
    private let decoder = JSONDecoder()
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
    }

    func getAllTodos() async throws -> GoalsResponseDto {
        do {
            let response = try await session
                .request(TodoRouter.getAllTodos(userId: User.shared.id!))
                .serializingDecodable(GoalsResponseDto.self)
                .value
            return response
        } catch {
            print("Error fetching todos: \(error)")
            throw error
        }
    }
    
    func addTodo(goalId: Int, todo: Todo) async throws -> TodoDto {
        do {
            let response = try await session
                .request(TodoRouter.addTodo(userId: User.shared.id!, goalId: goalId, todo: todo))
                .serializingDecodable(TodoDto.self)
                .value
            return response
        } catch {
            print("Error adding todo: \(error)")
            throw error
        }
    }
    
    func deleteTodo(goalId: Int, todoId: Int) async throws {
        do {
            let response = try await session
                .request(TodoRouter.deleteTodo(userId: User.shared.id!, goalId: goalId, todoId: todoId))
                .serializingString()
                .value
        } catch {
            throw error
        }
    }

    func updateTodo(todo: Todo) async throws -> TodoDto? {
        guard let todoId = todo.id else { return nil }
        do {
            let response = try await session
                .request(TodoRouter.updateTodo(userId: User.shared.id!, todoId: todoId, todo: todo))
                .serializingDecodable(TodoDto.self)
                .value
            print("response: \(response)")
            return response
        }
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
