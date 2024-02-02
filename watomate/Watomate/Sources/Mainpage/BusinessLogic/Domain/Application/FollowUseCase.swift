//
//  FollowUseCase.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class FollowUseCase {
    private let followRepository: FollowRepositoryProtocol
    
    init(followRepository: some FollowRepositoryProtocol) {
        self.followRepository = followRepository
    }
    
    func getFollowInfo() async throws -> (followers: [Follow], followings: [Follow]) {
        let dto = try await followRepository.getFollowInfo()
        let followers = dto.followers.map { $0.toDomain() }
        let followings = dto.following.map { $0.toDomain() }
        
        return (followers, followings)
    }
}
