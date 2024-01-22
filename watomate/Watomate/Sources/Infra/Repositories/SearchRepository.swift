//
//  SearchRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol SearchRepositoryProtocol {
    func getAllUsers() async throws -> UsersPage
    func getMoreUsers(url: String) async throws -> UsersPage
}

class SearchRepository: SearchRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getAllUsers() async throws -> UsersPage {
        let dto = try await session.request(SearchRouter.getAllUsers)
            .serializingDecodable(AllUsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getMoreUsers(url: String) async throws -> UsersPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(AllUsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
}
