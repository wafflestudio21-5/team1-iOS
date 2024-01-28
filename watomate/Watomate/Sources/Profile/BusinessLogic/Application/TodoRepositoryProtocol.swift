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
    func addTodo(goalId: Int, todo: Todo) async throws -> TodoDto
    func deleteTodo(goalId: Int, todoId: Int) async throws
//    func changeTitle(with id: Int, title: String)
//    func changeMemo(with id: Int, memo: String)
//    func changeReminder(with id: Int, time: String)
//    func changeDate(with id: Int, date: String)
}
