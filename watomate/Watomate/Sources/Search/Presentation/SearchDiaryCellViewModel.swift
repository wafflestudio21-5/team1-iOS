//
//  SearchDiaryCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class SearchDiaryCellViewModel: Identifiable {
    private let diary: SearchDiary
    
    let id: Int
    
    var likes: [SearchLike]
    
    var comments: [SearchComment]
    
    init(diary: SearchDiary) {
        self.diary = diary
        id = diary.id
        likes = diary.likes
        comments = diary.comments
    }
    
    var diaryId: Int {
        diary.id
    }
    
    var userId: Int {
        diary.user.id
    }
    
    var username: String {
        diary.user.username
    }
    
    var profilePic: String? {
        diary.user.profilePic
    }
    
    var description: String {
        diary.description
    }
    
    var visibility: Visibility {
        diary.visibility
    }
    
    var mood: Int? {
        diary.mood
    }
    
    var color: Color {
        diary.color
    }
    
    var emoji: String {
        diary.emoji
    }
    
    var image: String? {
        diary.image
    }
    
    var date: String {
        diary.date
    }
    
    func getDiary() -> SearchDiary {
        diary
    }

}
