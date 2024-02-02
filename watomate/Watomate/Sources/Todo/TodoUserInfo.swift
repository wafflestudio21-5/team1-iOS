//
//  TodoUserInfo.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct TodoUserInfo {
    let id: Int
    let tedoori: Bool
    let profilePic: String?
    let username: String
    let intro: String?
    
    init(userCellViewModel: UserCellViewModel) {
        id = userCellViewModel.userId
        tedoori = userCellViewModel.tedoori
        profilePic = userCellViewModel.profilePic
        username = userCellViewModel.username
        intro = userCellViewModel.intro
    }
    
    init(id: Int, tedoori: Bool, profilePic: String?, username: String, intro: String?) {
        self.id = id
        self.tedoori = tedoori
        self.profilePic = profilePic
        self.username = username
        self.intro = intro
    }
}
