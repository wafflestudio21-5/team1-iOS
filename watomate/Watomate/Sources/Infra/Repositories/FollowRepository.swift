//
//  FollowRepository.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol FollowRepositoryProtocol {
    func getFollowInfo() async throws -> FollowResponseDto
}

class FollowRepository: FollowRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getFollowInfo() async throws -> FollowResponseDto {
        let dto = try await session
            .request(FollowRouter.getFollowInfo(userId: User.shared.id!))
            .serializingDecodable(FollowResponseDto.self) //decoder : decoder 없애니까 됨..뭐지?
            .handlingError()
        return dto
    }
}
