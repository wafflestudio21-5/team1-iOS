//
//  TodoItemRepositoryProtocol.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

protocol TodoRepositoryProtocol {
    func getAllTodos() async throws -> GoalsResponseDto
    func getTodos(on date: String) async throws -> GoalsResponseDto
    func addTodo(goalId: Int, todo: Todo) async throws -> TodoDto
    func deleteTodo(goalId: Int, todoId: Int) async throws
    func updateTodo(todo: Todo) async throws -> TodoDto?
}
