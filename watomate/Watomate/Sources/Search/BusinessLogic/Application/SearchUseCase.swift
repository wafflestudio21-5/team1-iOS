//
//  SearchUseCase.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class SearchUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func getAllUsers() async throws -> UsersPage {
        let usersPage = try await searchRepository.getAllUsers()
        return usersPage
    }
    
    func getMoreUsers(nextURL: String) async throws -> UsersPage {
        let usersPage = try await searchRepository.getMoreUsers(url: nextURL)
        return usersPage
    }
}
