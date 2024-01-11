//
//  Diary.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/10.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
@MainActor

struct Diary: Codable{
    let id: Int
    let description: String
    let visibility : String
    let mood : Int
    let color: String
    let emoji: Int
    let image: String
    let created_by: Int
    let date: String
    let likes: [Like]
    let comments :[Comment]
}

struct Like: Codable{
    let user : Int
}

struct Comment: Codable{
    let created_at : String //?
    let user : Int
    let description : String
    let likes : [Like]
}
