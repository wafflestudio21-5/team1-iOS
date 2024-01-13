//
//  TodoUseCase.swift
//  Watomate
//
//  Created by 권현구 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class TodoUseCase {
    private let todoRepository: TodoItemRepositoryProtocol
    lazy var goals: [Goal] = []
    
    var dummy: [Goal] = [
        Goal(id: 1,
             title: "goal 1",
             visibility: .PB,
             color: "blue",
             createdAt: "2024-01-01",
             todos: [
                Todo(id: 1, title: "todo 1-1", createdAt: "2024-01-01", isCompleted: true, goal: 1, likes: []),
                Todo(id: 2, title: "todo 1-2", createdAt: "2024-01-01", isCompleted: false, goal: 1, likes: [])
             ]
            ),
        Goal(id: 2,
             title: "goal 2",
             visibility: .FL,
             color: "yellow",
             createdAt: "2024-01-02",
             todos: [
                Todo(id: 3, title: "todo 2-1", createdAt: "2024-01-02", isCompleted: true, goal: 2, likes: []),
                Todo(id: 4, title: "todo 2-2", createdAt: "2024-01-03", isCompleted: false, goal: 2, likes: [])
             ]
            )
    ]
    
    init(todoRepository: TodoItemRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func getTodos(with userId: Int) async throws -> [Goal] {
        let goalDto = try await todoRepository.getTodos()//id 넣도록 수정하기
        let goals = convert(goalsDto: goalDto)
//        let goals = dummy
        self.goals = goals
        return goals
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
        let goal = Goal(id: goalDto.id, title: goalDto.title, visibility: visibility, color: goalDto.color, createdAt: goalDto.created_at, todos: todos)
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
            id: todoDto.id,
            title: todoDto.title,
            createdAt: todoDto.created_at,
            isCompleted: todoDto.is_completed,
            goal: goalId,
            likes: todoDto.likes.map{ dto in
                Like(userId: dto.user)
            })
        return todo
    }
}
