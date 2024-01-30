//
//  TodoUseCase.swift
//  Watomate
//
//  Created by 권현구 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoUseCase {
    private let todoRepository: TodoRepositoryProtocol
    lazy var goals: [Goal] = []
    
    init(todoRepository: some TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func getAllTodos() async throws -> [Goal] {
        let goalsDto = try await todoRepository.getAllTodos()
        let goals = goalsDto.map { $0.toDomain() }
        self.goals = goals
        return goals
    }
    
    func addTodo(_ goalId: Int, _ todo: Todo) async throws -> Todo {
        let todoDto = try await todoRepository.addTodo(goalId: goalId, todo: todo)
        let todo = todoDto.toDomain()
        
        for i in 0..<goals.count {
            if goals[i].id == todo.goal {
                goals[i].todos.append(todo)
                return todo
            }
        }
        return todo
    }
    
    func deleteTodo(_ goalId: Int, _ todoId: Int) async throws {
        try await todoRepository.deleteTodo(goalId: goalId, todoId: todoId)
        guard var goal = goal(with: goalId) else {
            print("no such goal id: \(goalId)")
            return
        }
        guard let index = goal.todos.firstIndex(where: { todo in
            todo.id == todoId
        }) else { return }
        goal.todos.remove(at: index)
    }
    
    func updateTodo(_ todo: Todo) async throws {
        guard var goal = goal(with: todo.goal) else {
            print("goal not found")
            return }
        for i in 0..<goal.todos.count {
            if goal.todos[i].id == todo.id {
                goal.todos[i] = todo
                break
            }
        }
        guard let todoDto = try await todoRepository.updateTodo(todo: todo) else { return }
        let updatedTodo = todoDto.toDomain()
    }
    
    private func todo(_ goalId: Int, _ todoId: Int) -> Todo? {
        guard let goal = goal(with: goalId) else { return nil }
        for todo in goal.todos {
            if todo.id == todoId {
                return todo
            }
        }
        return nil
    }
    
    private func goal(with goalId: Int) -> Goal? {
        for goal in goals {
            if goal.id == goalId {
                return goal
            }
        }
        return nil
    }
}
