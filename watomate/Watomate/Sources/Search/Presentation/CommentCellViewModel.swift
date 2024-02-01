//
//  CommentCellViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class CommentCellViewModel: Identifiable {
//    enum Input {
//        case editTapped(comment: String)
//        case deleteTapped
//    }
//    
//    enum Output {
//        case editSuccess(comment: String)
//        case deleteSuccess
//    }
//    
//    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
//        input.sink { [weak self] event in
//            switch event {
//            case let .editTapped(comment):
//                self?.editComment(comment: comment)
//            case .deleteTapped:
//                self?.deleteComment()
//            }
//        }.store(in: &cancellables)
//        
//        return output.eraseToAnyPublisher()
//    }
//    
//    private var searchUseCase: SearchUseCase
//    
//    let input = PassthroughSubject<Input, Never>()
//    private let output = PassthroughSubject<Output, Never>()
//    private var cancellables = Set<AnyCancellable>()
    
    let id: Int
    let createdAt: String
    let user: Int
    let username: String
    let profilePic: String?
    var description: String
    var likes: [SearchLike]
    var color: Color
    
    init(comment: SearchComment, color: Color) {
//        self.searchUseCase = searchUseCase
        id = comment.id
        createdAt = comment.createdAtIso
        user = comment.user
        username = comment.username
        profilePic = comment.profilePic
        description = comment.description
        likes = comment.likes
        self.color = color
    }
    
//    func editComment(comment: String) {
//        Task {
//            do {
//                try await searchUseCase.editComment(commentId: id, description: comment)
//                output.send(.editSuccess(comment: comment))
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    func deleteComment() {
//        Task {
//            do {
//                try await searchUseCase.deleteComment(commentId: id)
//                
//            } catch {
//                print(error)
//            }
//        }
//    }
}
