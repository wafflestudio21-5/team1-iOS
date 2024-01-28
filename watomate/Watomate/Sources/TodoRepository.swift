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

    func getAllTodos() async throws -> GoalsResponseDto{
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
    
//    func deleteTodo(with id: Int) {
//        <#code#>
//    }
//    
//    func changeTitle(with id: Int, title: String) {
//        <#code#>
//    }
//    
//    func changeMemo(with id: Int, memo: String) {
//        <#code#>
//    }
//    
//    func changeReminder(with id: Int, time: String) {
//        <#code#>
//    }
//    
//    func changeDate(with id: Int, date: String) {
//        <#code#>
//    }

//    var numberOfItems: Int {
//        todoItems.count
//    }
//
//    func indexPath(with id: UUID) -> IndexPath? {
//        guard let firstIndex = todoItems.firstIndex(where: { $0.id == id }) else { return nil }
//        return .init(row: firstIndex, section: 0)
//    }
//
//    func get(with id: UUID) -> TodoItem? {
//        guard let indexPath = indexPath(with: id) else { return nil }
//        return get(at: indexPath)
//    }
//
//    func get(at indexPath: IndexPath) -> TodoItem? {
//        print(indexPath.row)
//        print(todoItems[indexPath.row])
//        return todoItems[safe: indexPath.row]
//    }
//
//    func append(_ todoItem: TodoItem) {
//        todoItems.append(todoItem)
//    }
//
//    func insert(_ todoItem: TodoItem, at indexPath: IndexPath) {
//        todoItems.insert(todoItem, at: indexPath.row)
//    }
//
//    func remove(_ todoItem: TodoItem) {
//        guard let indexPath = indexPath(with: todoItem.id) else { return }
//        todoItems.remove(at: indexPath.row)
//    }
//
//    func update(_ newValue: TodoItem) {
//        guard let indexPath = indexPath(with: newValue.id) else { return }
//        todoItems[indexPath.row] = newValue
//        print("updated to new value:\(newValue) at \(indexPath)")
//    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
