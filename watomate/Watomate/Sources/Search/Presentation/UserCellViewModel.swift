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
    
    let id = UUID()
    
    var userId: Int {
        userInfo.id
    }
    
    var username: String {
        userInfo.username
    }
    var tedoori: Bool {
        userInfo.tedoori
    }
    
    var intro: String {
        userInfo.intro ?? ""
    }
    
    var color: [Color] {
        userInfo.goalColors.map{ Color(rawValue: $0) ?? Color.gray }
    }
    
    var profilePic: String? {
        userInfo.profilePic
    }
}
