//
//  DiaryFeedViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum DiaryFeedSection: CaseIterable {
    case main
}

final class DiaryFeedViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case reachedEndOfScrollView
    }
    
    enum Output {
        case updateDiaryList(diaryList: [DiaryCellViewModel])
    }
    
    private var searchUseCase: SearchUseCase
    private var diaryList = [DiaryCellViewModel]()
    private var isFetching: Bool = false
    private var canFetchMoreDiaries: Bool = true
    private var nextUrl: String? = nil
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
    }
    
    func viewModel(at indexPath: IndexPath) -> DiaryCellViewModel {
        return diaryList[indexPath.row]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchInitialDiaries()
            case .reachedEndOfScrollView:
                self?.fetchMoreDiaries()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchInitialDiaries() {
        if isFetching || !canFetchMoreDiaries { return }
        isFetching = true
        Task {
            guard let diariesPage = try? await searchUseCase.getInitialDiaries(id: User.shared.id!) else {
                isFetching = false
                return
            }
            nextUrl = diariesPage.nextUrl
            if nextUrl == nil { canFetchMoreDiaries = false }
            diaryList.append(contentsOf: diariesPage.results.map{ DiaryCellViewModel(diary: $0) })
            output.send(.updateDiaryList(diaryList: diaryList))
            isFetching = false
//            fetchMoreUsers()
        }
    }
    
    private func fetchMoreDiaries() {
        if isFetching || !canFetchMoreDiaries { return }
        isFetching = true
        Task {
            guard let diariesPage = try? await searchUseCase.getMoreDiaries(nextUrl: nextUrl!) else {
                isFetching = false
                return
            }
            nextUrl = diariesPage.nextUrl
            if nextUrl == nil { canFetchMoreDiaries = false }
            diaryList.append(contentsOf: diariesPage.results.map{ DiaryCellViewModel(diary: $0) })
            output.send(.updateDiaryList(diaryList: diaryList))
            isFetching = false
        }
    }
}
