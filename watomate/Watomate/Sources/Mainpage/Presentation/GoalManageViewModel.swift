//
//  GoalManageViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//


class GoalManageViewModel {
    private let todoUseCase: TodoUseCase
    var goal: [Goal] = []
    
    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
    }
    
    func loadGoals(completion: @escaping () -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let goals = try await self.todoUseCase.getAllTodos()
                self.goal = goals
                completion() 
            } catch {
                print("Error loading goals: \(error)")
            }
        }
    }

}

