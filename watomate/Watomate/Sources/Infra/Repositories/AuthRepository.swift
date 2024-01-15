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
    func signupWithEmail(email: String, password: String) async throws -> SignupResponseDto
}

class AuthRepository: AuthRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func signupWithEmail(email: String, password: String) async throws -> SignupResponseDto {
        return try await session.request(AuthRouter.signupWithEmail(email: email, password: password))
            .serializingDecodable(SignupResponseDto.self, decoder: decoder).handlingError()
    }
}
