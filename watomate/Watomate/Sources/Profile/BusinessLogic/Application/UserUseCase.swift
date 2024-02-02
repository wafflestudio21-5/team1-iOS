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
    private let userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol, userDefaultsRepository: UserDefaultsRepositoryProtocol) {
        self.userRepository = userRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func changeProfilePic(id: Int, imageData: Data?) async throws {
        let profileUrl = try await userRepository.changeProfilePic(id: id, imageData: imageData)
        
        userDefaultsRepository.set(String.self, key: .profilePic, value: profileUrl)
        User.shared.profilePic = profileUrl
    }
    
    func changeUserInfo(id: Int, username: String, intro: String) async throws {
        try await userRepository.changeUserInfo(id: id, username: username, intro: intro)
        userDefaultsRepository.set(String.self, key: .username, value: username)
        userDefaultsRepository.set(String.self, key: .intro, value: intro)
        User.shared.username = username
        User.shared.intro = intro
    }
    
    func getInitialImages() async throws -> ImagePage {
        return try await userRepository.getAllImage()
    }
    
    func getMoreImages(url: String) async throws -> ImagePage {
        return try await userRepository.getMoreImage(url: url)
    }
    
    func getUserTodo(id: Int) async throws -> [UserGoal] {
        return try await userRepository.getUserTodo(id: id)
    }
}
