//
//  TodoItemRepositoryProtocol.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

protocol TodoRepositoryProtocol {
//    var numberOfItems: Int { get }
//    func get(with id: UUID) -> TodoItem?
//    func get(at indexPath: IndexPath) -> Todo?
//    func indexPath(with id: UUID) -> IndexPath?
//    func append(_ todoItem: TodoItem)
//    func insert(_ todoItem: TodoItem, at indexPath: IndexPath)
//    func remove(_ todoItem: TodoItem)
//    func update(_ todoItem: TodoItem)
    
    func getAllTodos() async throws -> GoalsResponseDto
    func addTodo(goalId: Int, todo: Todo) async throws -> TodoDto
//    func deleteTodo(with id: Int)
//    func changeTitle(with id: Int, title: String)
//    func changeMemo(with id: Int, memo: String)
//    func changeReminder(with id: Int, time: String)
//    func changeDate(with id: Int, date: String)
}
