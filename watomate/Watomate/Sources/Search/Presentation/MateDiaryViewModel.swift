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
        case deleteComment(commentId: Int)
        case commentSendTapped(comment: String)
    }
    
    enum Output {
        case successSaveLike(emoji: String)
        case showComments(comments: [CommentCellViewModel])
        case updateComments(comments: [CommentCellViewModel])
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                self.output.send(.showComments(comments: self.comments))
            case let .commentSendTapped(comment):
                saveComment(comment: comment)
            case let .deleteComment(commentId):
                deleteComment(commentId: commentId)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private var searchUseCase: SearchUseCase
    
    let input = PassthroughSubject<Input, Never>()
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    let id: Int
    var likes: [SearchLike]
    var comments = [CommentCellViewModel]()
    var diaryId: Int
    var userId: Int
    var username: String
    var profilePic: String?
    var description: String
    var visibility: Visibility
    var mood: Int?
    var color: Color
    var emoji: String
    var image: String?
    var date: String
    
    init(diary: SearchDiaryCellViewModel, searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
        id = diary.id
        likes = diary.likes
        diaryId = diary.diaryId
        userId = diary.userId
        username = diary.username
        profilePic = diary.profilePic
        description = diary.description
        visibility = diary.visibility
        mood = diary.mood
        color = diary.color
        emoji = diary.emoji
        image = diary.image
        date = diary.date
        comments = diary.comments.map{ CommentCellViewModel(comment: $0, color: diary.color) }
        
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
    
    private func saveComment(comment: String) {
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
    
    private func deleteComment(commentId: Int) {
        Task {
            do {
                try await searchUseCase.deleteComment(commentId: commentId)
                if let index = comments.firstIndex(where: { $0.id == commentId }) {
                    comments.remove(at: index)
                }
                output.send(.showComments(comments: comments))
            } catch {
                print(error)
            }
        }
    }
    
}
