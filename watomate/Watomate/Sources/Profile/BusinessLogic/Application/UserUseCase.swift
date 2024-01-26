//
//  UserUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class UserUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func changeProfilePic(id: Int, imageData: Data?) async throws {
        try await userRepository.changeProfilePic(id: id, imageData: imageData)
    }
    
    func changeUserInfo(id: Int, username: String, intro: String) async throws {
        try await userRepository.changeUserInfo(id: id, username: username, intro: intro)
    }
}
