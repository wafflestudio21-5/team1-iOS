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
        let goalDto = try await todoRepository.getAllTodos()//id 넣도록 수정하기
        let goals = convert(goalsDto: goalDto)
        self.goals = goals
        return goals
    }
    
    func addTodo(userId: Int, goalId: Int, todo: Todo) async {
        await todoRepository.addTodo(userId: userId, goalId: goalId, todo: todo)
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
        let goal = Goal(id: goalDto.id, title: goalDto.title, visibility: visibility, color: goalDto.color, createdAt: goalDto.created_at_iso, todos: todos)
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
            description: todoDto.description,
            reminder: todoDto.reminder_iso,
//            createdAt: todoDto.created_at_iso,
//            date: todoDto.date,
            isCompleted: todoDto.is_completed,
            goal: goalId,
            likes: todoDto.likes.map{ dto in
                Like(userId: dto.user)
            })
        return todo
    }
}
