//
//  MateDiaryViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

enum CommentSection: CaseIterable {
    case main
}

class MateDiaryViewModel: ViewModelType {
    
    enum Input {
        case viewDidLoad
        case commentSendTapped(comment: String)
    }
    
    enum Output {
        case successSaveLike(emoji: String)
        case firstComments(comments: [CommentCellViewModel])
        case updateComments(comments: [CommentCellViewModel])
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                self.output.send(.firstComments(comments: self.comments))
            case let .commentSendTapped(comment):
                saveComment(comment: comment)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private let diary: SearchDiary
    private var searchUseCase: SearchUseCase
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    let id: Int
    
    var likes: [SearchLike]
    
    var comments = [CommentCellViewModel]()
    
    init(diaryCellViewModel: SearchDiaryCellViewModel, searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
        self.diary = diaryCellViewModel.getDiary()
        id = diary.id
        likes = diary.likes
        comments = diary.comments.map{ CommentCellViewModel(comment: $0, color: diary.color) }
    }
    
    var diaryId: Int {
        diary.id
    }
    
    var userId: Int {
        diary.user.id
    }
    
    var username: String {
        diary.user.username
    }
    
    var profilePic: String? {
        diary.user.profilePic
    }
    
    var description: String {
        diary.description
    }
    
    var visibility: Visibility {
        diary.visibility
    }
    
    var mood: Int? {
        diary.mood
    }
    
    var color: Color {
        diary.color
    }
    
    var emoji: String {
        diary.emoji
    }
    
    var image: String? {
        diary.image
    }
    
    var date: String {
        diary.date
    }
    
    var isLiked:Bool {
       likes.contains(where: { $0.user == User.shared.id })
    }
    
    func commentViewModel(at indexPath: IndexPath) -> CommentCellViewModel {
        return comments[indexPath.row]
    }
    
    func saveLike(diaryId: Int, userId: Int, emoji: String) {
        Task {
            do {
                try await searchUseCase.postLike(diaryId: diaryId, user: userId, emoji: emoji)
                if let index = likes.lastIndex(where: { $0.user == userId }) {
                    likes.remove(at: index)
                }
                likes.append(SearchLike(user: userId, emoji: emoji))
                output.send(.successSaveLike(emoji: emoji))
            } catch {
                print(error)
            }
        }
    }
    
    func saveComment(comment: String) {
        Task {
            do {
                let commentResult = try await searchUseCase.postComment(diaryId: diaryId, userId: User.shared.id!, description: comment)
                comments.append(CommentCellViewModel(comment: commentResult, color: color))
                output.send(.updateComments(comments: comments))
            } catch {
                print(error)
            }
        }
    }
    
}
