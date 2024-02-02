//
//  Follow.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct FollowInfo : Codable{
    let followings: [Follow]
    let followers: [Follow]
    
}
struct Follow : Codable {
    let id: Int
    let profile: FollowProfile
}

struct FollowProfile : Codable{
    let username: String
    let profilePic: String?
    let intro: String?
    let tedoori: Bool
}

