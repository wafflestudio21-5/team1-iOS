//
//  AuthUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

enum LoginMethod: String {
    case email
    case kakao
    case guest
}

class AuthUseCase {
    private let kakaoRepository: KakaoRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol, userDefaultsRepository: UserDefaultsRepositoryProtocol, kakaoRepository: KakaoRepositoryProtocol) {
        self.authRepository = authRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.kakaoRepository = kakaoRepository
    }
    
    func signupWithEmail(email: String, password: String) async throws {
        let loginInfo = try await authRepository.signupWithEmail(email: email, password: password)
        saveLoginInfo(loginMethod: .email, loginInfo: loginInfo)
    }
    
    func signupGuest() async throws {
        let loginInfo = try await authRepository.signupGuest()
        saveLoginInfo(loginMethod: .guest, loginInfo: loginInfo)
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        let loginInfo = try await authRepository.loginWithEmail(email: email, password: password)
        saveLoginInfo(loginMethod: .email, loginInfo: loginInfo)
    }
    
    func loginWithKakao() async throws {
        if kakaoRepository.isKakaoTalkAvailable {
            try await kakaoRepository.loginWithApp()
        } else {
            try await kakaoRepository.loginWithWeb()
        }
        let kakaoId = try await kakaoRepository.getKakaoId()
        let loginInfo = try await authRepository.loginWithKakao(kakaoId: kakaoId)
        saveLoginInfo(loginMethod: .kakao, loginInfo: loginInfo)
    }
    
    private func saveLoginInfo(loginMethod: LoginMethod, loginInfo: LoginInfo) {
        User.shared.id = loginInfo.id
        User.shared.token = loginInfo.token
        User.shared.isLoggedin = true
        User.shared.loginMethod = loginMethod
        userDefaultsRepository.set(String.self, key: .accessToken, value: loginInfo.token)
        userDefaultsRepository.set(Int.self, key: .userId, value: loginInfo.id)
        userDefaultsRepository.set(Bool.self , key: .isLoggedIn, value: true)
        userDefaultsRepository.set(String.self, key: .loginMethod, value: loginMethod.rawValue)
    }
    
}