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
    func deleteAccount() async throws
    func guestLogin(email: String, password: String) async throws
}

class AuthRepository: AuthRepositoryProtocol {
    private let af = AF
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func signupWithEmail(email: String, password: String) async throws -> LoginInfo {
        let dto = try await af.request(AuthRouter.signupWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func signupWithKakao(kakaoId: Int64) async throws -> LoginInfo {
        let dto = try await af.request(AuthRouter.signupWithKakao(kakaoId: kakaoId))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func signupGuest() async throws -> LoginInfo {
        let dto = try await af.request(AuthRouter.signupGuest)
            .serializingDecodable(GuestResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func loginWithEmail(email: String, password: String) async throws -> LoginInfo {
        let dto = try await af.request(AuthRouter.loginWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func loginWithKakao(kakaoId: Int64) async throws -> LoginInfo {
        do {
            let dto = try await af.request(AuthRouter.loginWithKakao(kakaoId: kakaoId))
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
    
    func deleteAccount() async throws {
        try await session.request(AuthRouter.deleteAccount).serializingData().handlingError()
    }
    
    func guestLogin(email: String, password: String) async throws {
        try await session.request(AuthRouter.guestLogin(email: email, password: password)).serializingDecodable(GuestLoginResponseDto.self, decoder: decoder).handlingError()
    }
}
