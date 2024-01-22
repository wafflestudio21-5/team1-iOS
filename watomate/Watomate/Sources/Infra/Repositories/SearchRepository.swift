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
    func getInitialUsers() async throws -> UsersPage
    func getMoreUsers(url: String) async throws -> UsersPage
    func getInitialDiaries(id: Int) async throws -> DiariesPage
    func getMoreDiaries(url: String) async throws -> DiariesPage
}

class SearchRepository: SearchRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getInitialUsers() async throws -> UsersPage {
        let dto = try await session.request(SearchRouter.getAllUsers)
            .serializingDecodable(AllUsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getMoreUsers(url: String) async throws -> UsersPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(AllUsersResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getInitialDiaries(id: Int) async throws -> DiariesPage {
        let dto = try await session.request(SearchRouter.getDiaryFeed(id: id))
            .serializingDecodable(DiaryFeedResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
    
    func getMoreDiaries(url: String) async throws -> DiariesPage {
        let dto = try await session.request(URL(string: url)!)
            .serializingDecodable(DiaryFeedResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
}
