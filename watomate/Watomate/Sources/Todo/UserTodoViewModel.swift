//
//  UserTodoViewModel.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class UserTodoViewModel {
    private let userInfo: TodoUserInfo
    
    init(userInfo: TodoUserInfo) {
        self.userInfo = userInfo
    }
    
    var username: String {
        userInfo.username
    }
    
    var profilePic: String? {
        userInfo.profilePic
    }
    
    var intro: String? {
        userInfo.intro
    }
}
