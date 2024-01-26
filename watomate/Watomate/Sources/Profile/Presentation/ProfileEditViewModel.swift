//
//  ProfileEditViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class ProfileEditViewModel {
    enum Input {
        case usernameEdited(username: String)
        case introEdited(intro: String)
        case profilePicEdited(imageData: Data?)
        case okButtonTapped
    }
    
    private let userUseCase: UserUseCase
    
    private var username: String = ""
    private var intro: String = ""
    
    let input = PassthroughSubject<Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        
        bindInput()
    }
    
    private func bindInput() {
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
                    try? await self.userUseCase.changeProfilePic(id: id, imageData: imageData)
                }
            case .okButtonTapped:
                Task {
                    try? await self.userUseCase.changeUserInfo(id: id, username: self.username, intro: self.intro)
                }
            }
        }.store(in: &cancellables)
    }
    
}
