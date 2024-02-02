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
}
