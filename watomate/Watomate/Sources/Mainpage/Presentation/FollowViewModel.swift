//
//  FollowViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class FollowViewModel {
    private let followUseCase: FollowUseCase
    
    init(followUseCase: FollowUseCase) {
        self.followUseCase = followUseCase
    }
    
    func getFollowInfo(completion: @escaping (Result<(followers: [Follow], followings: [Follow]), Error>) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let followInfo = try await followUseCase.getFollowInfo()
                completion(.success(followInfo))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func followUser(_ user_to_follow: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await followUseCase.followUser(user_to_follow: user_to_follow)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func unfollowUser(_ user_to_unfollow: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await followUseCase.unfollowUser(user_to_unfollow: user_to_unfollow)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func removeUser(_ user_to_remove: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await followUseCase.removeUser(user_to_remove: user_to_remove)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}
