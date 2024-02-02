//
//  CommentCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class CommentCellViewModel: Identifiable {
    
    let id: Int
    let createdAt: String
    let user: Int
    let username: String
    let profilePic: String?
    var description: String
    var likes: [SearchLike]
    var color: Color
    
    init(comment: SearchComment, color: Color) {
        id = comment.id
        createdAt = comment.createdAtIso
        user = comment.user
        username = comment.username
        profilePic = comment.profilePic
        description = comment.description
        likes = comment.likes
        self.color = color
    }
    
}
