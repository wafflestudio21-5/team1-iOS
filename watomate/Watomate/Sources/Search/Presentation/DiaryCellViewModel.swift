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
    
    var description: String {
        diary.description
    }
}
