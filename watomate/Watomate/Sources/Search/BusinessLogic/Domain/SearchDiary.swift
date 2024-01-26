//
//  Diary.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct SearchDiary {
    let user: UserInfo
    let description: String
    let visibility: String
    let mood: Int
    let color: String
    let emoji: Int
    let image: String?
    let date: String
    let likes: [SearchLike]
    let comments: [SearchComment]
}

struct SearchLike {
    let user: Int
    let emoji: Int
}

struct SearchComment {
    let createdAtIso: String
    let user: Int
    let description: String
    let likes: [SearchLike]
}
