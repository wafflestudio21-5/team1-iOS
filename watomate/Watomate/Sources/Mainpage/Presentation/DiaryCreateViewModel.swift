//
//  DiaryCreateViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/25.
//  Copyright © 2024 tuist.io. All rights reserved.
//


import Foundation

class DiaryCreateViewModel {
    private var useCase: DiaryUseCase

    init() {
        self.useCase = DiaryUseCase(diaryRepository: DiaryRepository())
    }
    
    func diaryFinishButtonTapped(diary: DiaryCreateDTO) async throws{
       try await useCase.createDiary(diary: diary)
    }
}

    
    



