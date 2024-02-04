//
//  FollowCountViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/03.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class FollowCountViewModel {
    private let useCase: SearchUseCase
    var user: [UserInfo] = []
    
    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }
    
    func getUserInfo(id: Int) async throws -> UserInfo {
        let userInfo = try await useCase.getUserInfo(id: id)
        return UserInfo(id: userInfo.id, tedoori: userInfo.tedoori, goalColors: userInfo.goalColors, intro: userInfo.intro, username: userInfo.username, profilePic: userInfo.profilePic, followerCount: userInfo.followerCount, followingCount: userInfo.followingCount)
    }

    
}
