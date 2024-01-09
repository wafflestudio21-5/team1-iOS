//
//  AuthRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

class AuthRepository: AuthRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func registerWithEmail(email: String, password: String) async throws -> LoginResponseDto {
        let response = try await session
            .request(AuthRouter.registerWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self)
            .value
        return response
    }
}
