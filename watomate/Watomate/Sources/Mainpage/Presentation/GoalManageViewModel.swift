//
//  GoalManageViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//
import Foundation

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
    
    func addGoal(_ goal: GoalCreate, completion: @escaping (Result<Goal, Error>) -> Void) {
        Task {
            do {
                let addedGoal = try await todoUseCase.addGoal(goal)
                DispatchQueue.main.async {
                    completion(.success(addedGoal))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    func patchGoal(_ goalId: Int, goal: GoalCreate, completion: @escaping (Result<Goal, Error>) -> Void) {
        Task {
            do {
                let updatedGoal = try await todoUseCase.patchGoal(goalId, goal: goal)
                DispatchQueue.main.async {
                    completion(.success(updatedGoal))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteGoal(_ goalId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await todoUseCase.deleteGoal(goalId)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}

