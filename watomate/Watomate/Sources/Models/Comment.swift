//
//  Comment.swift
//  Watomate
//
//  Created by 이지현 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct Comment: Codable{
    let id : Int
    let created_at_iso : String
    let user : Int
    let description : String
    let likes : [Like]?
}
