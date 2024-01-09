//
//  AuthRepositoryProtocol.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

protocol AuthRepositoryProtocol {
    func registerWithEmail(email: String, password: String) async throws -> LoginResponseDto
//    func loginWithEmail(email: String, password: String) async throws -> LoginResponseDto
//    func loginWithKakao(kakaoId: Int64) async throws -> LoginResponseDto
//    func guestLogin()
//    func sendVerificationCode(email: String) async throws
//    func checkVerificationCode(email: String) async throws
//    func logout(userId: String) async throws
}
