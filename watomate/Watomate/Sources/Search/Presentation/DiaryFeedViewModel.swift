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
        case likeTapped(diaryId: Int, userId: Int, emoji: String)
        case likeAppended(diaryId: Int, userId: Int, emoji: String)
        case updateComment(diaryId: Int,comments: [CommentCellViewModel])
    }
    
    enum Output {
        case updateDiaryList(diaryList: [SearchDiaryCellViewModel])
        case likeUpdate
    }
    
    private var searchUseCase: SearchUseCase
    private var diaryList = [SearchDiaryCellViewModel]()
    private var isFetching: Bool = false
    private var canFetchMoreDiaries: Bool = true
    private var nextUrl: String? = nil
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
    }
    
    func viewModel(at indexPath: IndexPath) -> SearchDiaryCellViewModel {
        return diaryList[indexPath.row]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchInitialDiaries()
            case .reachedEndOfScrollView:
                self?.fetchMoreDiaries()
            case let .likeTapped(diaryId, userId, emoji):
                self?.saveLike(diaryId: diaryId, userId: userId, emoji: emoji)
            case let .likeAppended(diaryId, userId, emoji):
                self?.appendLike(diaryId: diaryId, userId: userId, emoji: emoji)
            case let .updateComment(diaryId, comments):
                self?.updateComment(diaryId: diaryId, comments: comments)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchInitialDiaries() {
        if isFetching || !canFetchMoreDiaries { return }
        isFetching = true
        Task {
            do {
                let diariesPage = try await searchUseCase.getInitialDiaries(id: User.shared.id!)
                nextUrl = diariesPage.nextUrl
                if nextUrl == nil { canFetchMoreDiaries = false }
                diaryList.append(contentsOf: diariesPage.results.map{ SearchDiaryCellViewModel(diary: $0) })
                output.send(.updateDiaryList(diaryList: diaryList))
            } catch {
                print(error)
            }
            
            isFetching = false
        }
    }
    
    private func fetchMoreDiaries() {
        if isFetching || !canFetchMoreDiaries { return }
        isFetching = true
        Task {
            guard let url = self.nextUrl else {
                isFetching = false
                fetchInitialDiaries()
                return
            }
            guard let diariesPage = try? await searchUseCase.getMoreDiaries(nextUrl: url) else {
                isFetching = false
                return
            }
            nextUrl = diariesPage.nextUrl
            if nextUrl == nil { canFetchMoreDiaries = false }
            diaryList.append(contentsOf: diariesPage.results.map{ SearchDiaryCellViewModel(diary: $0) })
            output.send(.updateDiaryList(diaryList: diaryList))
            isFetching = false
        }
    }
    
    private func saveLike(diaryId: Int, userId: Int, emoji: String) {
        Task {
            do {
                try await searchUseCase.postLike(diaryId: diaryId, user: userId, emoji: emoji)
                if let index = diaryList.firstIndex(where: { $0.diaryId == diaryId }) {
                    var likes = diaryList[index].likes
                    if let idx = likes.lastIndex(where: { $0.user == userId }) {
                        likes.remove(at: idx)
                    }
                    likes.append(SearchLike(user: userId, emoji: emoji))
                    diaryList[index].likes = likes
                    diaryList[index].updateDiaryLikes(likes)
                    output.send(.likeUpdate)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private func appendLike(diaryId: Int, userId: Int, emoji: String) {
        if let index = diaryList.firstIndex(where: { $0.diaryId == diaryId }) {
            var likes = diaryList[index].likes
            if let idx = likes.lastIndex(where: { $0.user == userId }) {
                likes.remove(at: idx)
            }
            likes.append(SearchLike(user: userId, emoji: emoji))
            diaryList[index].likes = likes
            diaryList[index].updateDiaryLikes(likes)
            output.send(.likeUpdate)
        }
    }
    
    private func updateComment(diaryId: Int, comments: [CommentCellViewModel]) {
        if let index = diaryList.firstIndex(where: { $0.diaryId == diaryId }) {
            diaryList[index].comments = comments.map{ SearchComment(id: $0.id, createdAtIso: $0.createdAt, user: $0.user, username: $0.username, profilePic: $0.profilePic, description: $0.description, likes: $0.likes)  }
        }
    }
}
