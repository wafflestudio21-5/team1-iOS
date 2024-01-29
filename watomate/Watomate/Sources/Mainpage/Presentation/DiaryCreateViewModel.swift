//
//  DiaryCreateViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/25.
//  Copyright © 2024 tuist.io. All rights reserved.
//


import Foundation

class DiaryCreateViewModel {
    func createDiary(entry: DiaryCreate) {
           DiaryCreateService.shared.createDiary(entry: entry){ (response) in
            switch(response) {
            case .success:
                print("Created Diary")
            case .requestErr(let message) :
                print("requestErr", message)
            case .pathErr :
                print("pathErr")
            case .serverErr :
                print("serveErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            case .unknownErr:
                print("unknownErr")
            }
        }
    }
    
}

    
    



