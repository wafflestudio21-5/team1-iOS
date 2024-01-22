//
//  UserCellVIewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class UserCellViewModel: Identifiable {
    private let userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    var id = UUID()
    
    var username: String {
        userInfo.username
    }
    
    var intro: String {
        userInfo.intro ?? ""
    }
}
