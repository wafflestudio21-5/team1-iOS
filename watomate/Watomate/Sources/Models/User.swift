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
    
    var token: String?
    var isLoggedin: Bool = false
    var loginMethod: LoginMethod?
    
    var id: Int?
    var username: String?
    var intro: String?
    var profilePic: String? 
    var followerCount: Int?
    var followingCount: Int?
    
    private init() { }
}
