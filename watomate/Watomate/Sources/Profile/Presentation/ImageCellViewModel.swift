//
//  ImageCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class ImageCellViewModel: Identifiable {
    let id = UUID()
    let image: String
    let date: String
    let goalTitle: String
    let goalColor: String
    let todoTitle: String
    
    init(image: Image) {
        self.image = image.image
        self.date = image.date
        self.goalTitle = image.goalTitle
        self.goalColor = image.goalColor
        self.todoTitle = image.todoTitle
    }
}
