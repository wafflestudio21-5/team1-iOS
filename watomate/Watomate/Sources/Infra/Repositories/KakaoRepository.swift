//
//  KakaoRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

protocol KakaoRepositoryProtocol {
    var isKakaoTalkAvailable: Bool { get }
    func loginWithApp() async throws
    func loginWithWeb() async throws
    func getKakaoId() async throws -> Int64
    func logout()
}

class KakaoRepository: KakaoRepositoryProtocol {
    var isKakaoTalkAvailable: Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
    
    @MainActor
    func loginWithApp() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    @MainActor
    func loginWithWeb() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func getKakaoId() async throws -> Int64 {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    guard let kakaoId = user?.id else {
                        continuation.resume(throwing: NetworkError.kakaoLoginError)
                        return
                    }
                    continuation.resume(returning: kakaoId)
                }
            }
        }
    }
    
    func logout() {
        UserApi.shared.logout { error in
            if let error {
                return
            }
            return
        }
    }
    
}
