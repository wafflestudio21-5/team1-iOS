//
//  User.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class User {
    static let shared = User()
    
    var id: Int?
    var token: String?
    var username: String?
    
    private init() { }
}
