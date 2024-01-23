//
//  DiaryCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class DiaryCellViewModel: Identifiable {
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
    }
    
    let id = UUID()
    
    var user: UserInfo {
        diary.user
    }
    
    var description: String {
        diary.description
    }
    
    var mood: Int {
        diary.mood
    }
    
    var color: String {
        diary.color
    }
    
    var emoji: Int {
        diary.emoji
    }
    
    var image: String? {
        diary.image
    }
    
    var date: String? {
        diary.date
    }
    
    var likes: [Like] {
        diary.likes
    }
    
    var comments: [Comment] {
        diary.comments
    }
}
