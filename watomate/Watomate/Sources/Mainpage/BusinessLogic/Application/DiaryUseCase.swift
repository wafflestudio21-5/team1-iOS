//
//  DiaryUseCase.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/25.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation


class DiaryUseCase {
    private let diaryRepository: DiaryRepositoryProtocol
    
    init(diaryRepository: DiaryRepositoryProtocol) {
        self.diaryRepository = diaryRepository
    }
     
    func createDiary(diary: DiaryCreateDTO) async throws{
        try await diaryRepository.createDiary(diary: diary)
    }
    
    func getDiary(userID: Int, date: String) async throws -> Diary {
        let diary = try await diaryRepository.getDiary(userID: userID, date: date)
        return diary
    }
    
    func patchDiary(userID: Int, date: String, diary: DiaryCreateDTO) async throws  {
        let fixedDiary = try await patchDiary(userID: userID, date: date, diary: diary)
    }
    
}
