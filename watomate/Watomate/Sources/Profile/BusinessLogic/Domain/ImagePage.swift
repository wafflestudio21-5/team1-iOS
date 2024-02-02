//
//  ImagePage.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct ImagePage {
    let nextUrl: String?
    let images: [Image]
}

struct Image {
    let image: String
    let date: String
    let goalTitle: String
    let goalColor: String
    let todoTitle: String
}
