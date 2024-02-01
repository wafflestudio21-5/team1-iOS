//
//  ArchiveBoxViewModel.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class ArchiveBoxViewModel: ViewModelType {
    
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateImageList(imageList: [ImageCellViewModel])
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return output.eraseToAnyPublisher()
    }
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userUseCase = UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())
    
}
