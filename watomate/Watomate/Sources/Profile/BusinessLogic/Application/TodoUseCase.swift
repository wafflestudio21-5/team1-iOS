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
        let goalDto = try await todoRepository.getAllTodos()
        let goals = convert(goalsDto: goalDto)
        self.goals = goals
        return goals
    }
    
    func addTodo(_ goalId: Int, _ todo: Todo) async throws -> Todo {
        let todoDto = try await todoRepository.addTodo(goalId: goalId, todo: todo)
        let todo = convert(todoDto: todoDto, with: todoDto.goal)
        
        for i in 0..<goals.count {
            if goals[i].id == todo.goal {
                goals[i].todos.append(todo)
                return todo
            }
        }
        return todo
    }
    
    func deleteTodo(_ goalId: Int, _ todoId: Int) async {
        do {
            try await todoRepository.deleteTodo(goalId: goalId, todoId: todoId)
            // change self.goals
            guard var goal = goal(with: goalId) else {
                print("no such goal id: \(goalId)")
                return
            }
            guard let index = goal.todos.firstIndex(where: { todo in
                todo.id == todoId
            }) else { return }
            goal.todos.remove(at: index)
        } catch {
            print(error)
        }
    }
    
    func updateTodo(_ todo: Todo) async throws {
        do {
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
        } catch {
            print(error)
            return
        }
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
    
    private func convert(goalsDto: GoalsResponseDto) -> [Goal] {
        let goals = goalsDto.map { dto in
            convert(goalDto: dto)
        }
        return goals
    }
    
    private func convert(goalDto: GoalResponseDto) -> Goal {
        let goalId = goalDto.id
        let visibility = convert(visibility: goalDto.visibility)
        let todos = goalDto.todos.map { dto in
            convert(todoDto: dto, with: goalId)
        }
        let goal = Goal(id: goalDto.id, title: goalDto.title, visibility: visibility, color: goalDto.color, todos: todos)
        return goal
    }
    
    private func convert(visibility: String) -> Visibility {
        switch visibility {
        case "PB":
            return .PB
        case "PR":
            return .PR
        case "FL":
            return .FL
        default:
            return .PR
        }
    }
    
    private func convert(todoDto: TodoDto, with goalId: Int) -> Todo {
        let todo = Todo(
            uuid: UUID(),
            id: todoDto.id,
            title: todoDto.title,
            color: todoDto.color,
            description: todoDto.description,
            reminder: todoDto.reminder_iso,
//            date: todoDto.date,
            isCompleted: todoDto.is_completed,
            goal: goalId,
            likes: todoDto.likes.map{ dto in
                Like(userId: dto.user, emoji: dto.emoji)
            })
        return todo
    }
}
