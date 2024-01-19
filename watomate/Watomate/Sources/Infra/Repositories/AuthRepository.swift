//
//  AuthRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol AuthRepositoryProtocol {
    func signupWithEmail(email: String, password: String) async throws -> LoginInfo
    func signupWithKakao(kakaoId: Int64) async throws -> LoginInfo
    func signupGuest() async throws -> LoginInfo
    func loginWithEmail(email: String, password: String) async throws -> LoginInfo
    func loginWithKakao(kakaoId: Int64) async throws -> LoginInfo
}

class AuthRepository: AuthRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func signupWithEmail(email: String, password: String) async throws -> LoginInfo {
        let dto = try await session.request(AuthRouter.signupWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func signupWithKakao(kakaoId: Int64) async throws -> LoginInfo {
        let dto = try await session.request(AuthRouter.signupWithKakao(kakaoId: kakaoId))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func signupGuest() async throws -> LoginInfo {
        let dto = try await session.request(AuthRouter.signupGuest)
            .serializingDecodable(GuestResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func loginWithEmail(email: String, password: String) async throws -> LoginInfo {
        let dto = try await session.request(AuthRouter.loginWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func loginWithKakao(kakaoId: Int64) async throws -> LoginInfo {
        do {
            let dto = try await session.request(AuthRouter.loginWithKakao(kakaoId: kakaoId))
                .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
            return dto.toDomain()
        } catch {
            if let error = error as? NetworkError{
                if error.statusCode == 422 {
                    return try await signupWithKakao(kakaoId: kakaoId)
                }
            }
            throw error
        }
    }
}
