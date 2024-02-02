//
//  FollowDto.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct FollowResponseDto : Codable{
    let following: [FollowDto]
    let followers: [FollowDto]
    
    func toDomain() -> FollowInfo {
        return FollowInfo(followings: following.map {$0.toDomain()}, followers: followers.map{$0.toDomain()})
    }
}

struct FollowDto : Codable {
    let id: Int
    let profile: FollowProfileDto
    
    func toDomain() -> Follow {
        return Follow(id: id, profile: profile.toDomain())
    }
}

struct FollowProfileDto : Codable{
    let username: String
    let profile_pic: String?
    let tedoori: Bool
    
    func toDomain() -> FollowProfile {
        return FollowProfile(username: username, profilePic: profile_pic, tedoori: tedoori)
    }
    
}

