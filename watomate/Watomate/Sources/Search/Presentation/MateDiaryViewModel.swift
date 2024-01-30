//
//  MateDiaryViewModel.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import Foundation

class MateDiaryViewModel {
    private let diary: SearchDiary
    private var searchUseCase: SearchUseCase
    
    private let outputSubject = PassthroughSubject<String, Never>()
    var output: AnyPublisher<String, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    let id: Int
    
    var likes: [SearchLike]
    
    var comments: [SearchComment]
    
    init(diaryCellViewModel: SearchDiaryCellViewModel, searchUserCase: SearchUseCase) {
        self.searchUseCase = searchUserCase
        self.diary = diaryCellViewModel.getDiary()
        id = diary.id
        likes = diary.likes
        comments = diary.comments
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
    
    func saveLike(diaryId: Int, userId: Int, emoji: String) {
        Task {
            do {
                try await searchUseCase.postLike(diaryId: diaryId, user: userId, emoji: emoji)
                if let index = likes.lastIndex(where: { $0.user == userId }) {
                    likes.remove(at: index)
                }
                likes.append(SearchLike(user: userId, emoji: emoji))
                outputSubject.send(emoji)
            } catch {
                print(error)
            }
        }
    }
    
}
