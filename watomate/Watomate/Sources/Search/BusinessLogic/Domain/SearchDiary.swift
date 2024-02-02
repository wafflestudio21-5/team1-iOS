//
//  Diary.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct SearchDiary {
    let id: Int 
    let user: UserInfo
    let description: String
    let visibility: Visibility
    let mood: Int?
    let color: Color
    let emoji: String
    let image: String?
    let date: String
    var likes: [SearchLike]
    var comments: [SearchComment]
}

struct SearchLike {
    let user: Int
    let emoji: String
}

struct SearchComment {
    let id: Int
    let createdAtIso: String
    let user: Int
    let username: String
    let profilePic: String?
    let description: String
    let likes: [SearchLike]
}
