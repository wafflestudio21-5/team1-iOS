//
//  UserDto.swift
//  Watomate
//
//  Created by 이지현 on 2/1/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct ImageUploadResponseDto: Decodable {
    let image: String
}

struct AllImageResponseDto: Decodable {
    let next, previous: String?
    let results: [ImageDto]
    
    func toDomain() -> ImagePage {
        ImagePage(nextUrl: next, images: results.map{ $0.toDomain() })
    }
    
    struct ImageDto: Decodable {
        let image: String
        let date: String
        let goalTitle: String
        let goalColor: String
        let title: String
        
        func toDomain() -> Image {
            Image(image: image, date: date, goalTitle: goalTitle, goalColor: goalColor, todoTitle: title)
        }
    }
}

typealias UserTodoResponseDto = [UserTodoDto]

struct UserTodoDto: Decodable {
    let title: String
    let color: String
    let visibility: String
    let todos: [TodoDto]
    
    struct TodoDto: Decodable {
        let id: Int
        let title: String
        let color: String
        let isCompleted: Bool
        let likes: [SearchLikeDto]
        
        func toDomain() -> UserTodo {
            UserTodo(id: id, title: title, color: color, isCompleted: isCompleted, likes: likes.map{ $0.toDomain() })
        }
    }
    
    func toDomain() -> UserGoal {
        UserGoal(title: title, color: color, visibility: visibility, todos: todos.map{ $0.toDomain() })
    }
}

