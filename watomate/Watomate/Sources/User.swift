//
//  User.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class User {
    static let shared = User()
    
    var token: String?
    var isLoggedin: Bool = false
    var loginMethod: LoginMethod?
    
    var id: Int?
    var username: String?
    var intro: String?
    var profilePic: String? // 나중에 지울 것 
    var profileImage: UIImage? // url에서 받아온 이미지
    var followerCount: Int?
    var followingCount: Int?
    
    private init() { }
}
