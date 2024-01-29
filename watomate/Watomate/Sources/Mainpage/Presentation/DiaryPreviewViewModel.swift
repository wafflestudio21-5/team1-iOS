//
//  DiaryPreviewViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/26.
//  Copyright © 2024 tuist.io. All rights reserved.
//


import Foundation

class DiaryPreviewViewModel {
    private let diaryService = DiaryService.shared
    var diary: Diary?
    func getDiary(userID: Int, date: String, completion: @escaping () -> Void) {
        DiaryService.shared.getDiary(userID: userID, date: date) { (response) in
            switch(response) {
            case .success(let diaryData):
                if let data = diaryData as? Diary {
                    print(data.description)
                    self.diary = data
                }
                completion()

            case .requestErr(let message) :
                print("requestErr", message)
                completion()
            case .pathErr :
                print("pathErr")
                completion()
            case .serverErr :
                print("serveErr")
                completion()
            case .networkFail:
                print("networkFail")
                completion()
            case .decodeErr:
                print("decodeErr")
                completion()
            case .unknownErr:
                print("unknownErr")
                completion()
            }
        }
    }

    
}








