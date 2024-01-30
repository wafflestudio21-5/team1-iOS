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
    var diary: Diary? = nil
    func getDiary(userID: Int, date: String, completion: @escaping () -> Void) {
        DiaryService.shared.getDiary(userID: userID, date: date) { (response) in
            switch(response) {
            case .success(let diaryData):
                if let data = diaryData as? Diary {
                    self.diary = data
                }
                completion()
            case .requestErr(let message) :
                print("requestErr", message)
                self.diary = nil
                completion()
            case .pathErr :
                print("pathErr")
                self.diary = nil
                completion()
            case .serverErr :
                print("serveErr")
                self.diary = nil
                completion()
            case .networkFail:
                print("networkFail")
                self.diary = nil
                completion()
            case .decodeErr:
                print("decodeErr")
                self.diary = nil
                completion()
            case .unknownErr:
                print("unknownErr")
                self.diary = nil
                completion()
            }
        }
    }
    
    func deleteDiary(userID : Int, date: String) {
           DiaryService.shared.deleteDiary(userID: userID, date: date){ (response) in
            switch(response) {
            case .success:
                print("Deleted Diary")
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







