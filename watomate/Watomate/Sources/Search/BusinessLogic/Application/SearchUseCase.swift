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
    
    func getInitialUsers() async throws -> UsersPage {
        var usersPage = try await searchRepository.getInitialUsers()
        var results = usersPage.results
        for (index, result) in results.enumerated() {
            let goalsDto = try await searchRepository.getUserGoals(id: result.id)
            for goal in goalsDto {
                if goal.visibility == "PB" && !result.goalsColor.contains(goal.color) {
                    results[index].goalsColor.append(goal.color)
                }
            }
        }
        usersPage.results = results
        return usersPage
    }
    
    func getMoreUsers(nextUrl: String) async throws -> UsersPage {
        var usersPage = try await searchRepository.getMoreUsers(url: nextUrl)
        var results = usersPage.results
        for (index, result) in results.enumerated() {
            let goalsDto = try await searchRepository.getUserGoals(id: result.id)
            for goal in goalsDto {
                if goal.visibility == "PB" && !result.goalsColor.contains(goal.color) {
                    results[index].goalsColor.append(goal.color)
                }
            }
        }
        usersPage.results = results
        return usersPage
    }
    
    func getInitialDiaries(id: Int) async throws -> DiariesPage {
        let diariesPage = try await searchRepository.getInitialDiaries(id: id)
        return diariesPage
    }
    
    func getMoreDiaries(nextUrl: String) async throws -> DiariesPage {
        let diariesPage = try await searchRepository.getMoreDiaries(url: nextUrl)
        return diariesPage
    }
    
    func searchInitialUsers(username: String) async throws -> UsersPage {
        let usersPage = try await searchRepository.searchInitialUsers(username: username)
        return usersPage
    }
    
    func getTodoFeed() async throws -> TodoPage {
        let todoPage = try await searchRepository.getTodoFeed()
        return todoPage
    }
    
    func getMoreTodo(nextUrl: String) async throws -> TodoPage {
        let todoPage = try await searchRepository.getMoreTodo(url: nextUrl)
        return todoPage
    }
    
    func searchInitialTodo(title: String) async throws -> TodoPage {
        let todoPage = try await searchRepository.searchInitialTodo(title: title)
        return todoPage
    }
}
