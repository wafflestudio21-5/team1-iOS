//
//  ProfileEditViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class ProfileEditViewModel : ViewModelType {
    enum Input {
        case usernameEdited(username: String)
        case introEdited(intro: String)
        case profilePicEdited(imageData: Data?)
        case okButtonTapped
    }
    
    enum Output {
        case okProcessSuccess
        case okProcessFailed(errorMessage: String)
    }
    
    private let userUseCase: UserUseCase
    
    private var username: String = ""
    private var intro: String = ""
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self,
                  let id = User.shared.id else { return }
            switch event {
            case let .usernameEdited(username):
                self.username = username
            case let .introEdited(intro):
                self.intro = intro
            case let .profilePicEdited(imageData):
                Task {
                    do {
                        try await self.userUseCase.changeProfilePic(id: id, imageData: imageData)
                    } catch {
                        print(error)
                    }
                    
                }
            case .okButtonTapped:
                Task {
                    do {
                        try await self.userUseCase.changeUserInfo(id: id, username: self.username, intro: self.intro)
                        self.output.send(.okProcessSuccess)
                    } catch {
                        self.output.send(.okProcessFailed(errorMessage: error.localizedDescription))
                    }
                    
                }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    
}
