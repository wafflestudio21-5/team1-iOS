//
//  ArchiveBoxViewModel.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum ImageSection: CaseIterable {
    case main 
}

class ArchiveBoxViewModel: ViewModelType {
    
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateImageList(imageList: [ImageCellViewModel])
    }
    
    private var imageList = [ImageCellViewModel]()
    private var isFetching: Bool = false
    private var canFetchMoreImages: Bool = true
    private var nextUrl: String? = nil
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userUseCase = UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())
    
    func viewModel(at indexPath: IndexPath) -> ImageCellViewModel {
        return imageList[indexPath.row]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchInitialImages()
            case .reachedEndOfScrollView:
                self?.fetchMoreImages()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchInitialImages() {
        if isFetching || !canFetchMoreImages { return }
        isFetching = true
        Task {
            do {
                let imagePage = try await userUseCase.getInitialImages()
                nextUrl = imagePage.nextUrl
                if nextUrl == nil {
                    canFetchMoreImages = false
                }
                imageList.append(contentsOf: imagePage.images.map{ ImageCellViewModel(image: $0) })
                output.send(.updateImageList(imageList: imageList))
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
    private func fetchMoreImages() {
        if isFetching || !canFetchMoreImages { return }
        isFetching = true
        Task {
            do {
                guard let url = self.nextUrl else {
                    isFetching = false
                    fetchInitialImages()
                    return
                }
                let imagePage = try await userUseCase.getMoreImages(url: url)
                nextUrl = imagePage.nextUrl
                if nextUrl == nil {
                    canFetchMoreImages = false
                }
                imageList.append(contentsOf: imagePage.images.map{ ImageCellViewModel(image: $0) })
                output.send(.updateImageList(imageList: imageList))
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
}
