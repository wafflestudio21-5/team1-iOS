//
//  DiaryRouter.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

enum DiaryRouter: Router {
    
    case createDiary(diary: DiaryCreateDTO)
    case getDiary(userID : Int, date: String)
    case putDiary(userID : Int, date: String, diary : DiaryCreateDTO)
    case patchDiary(userID : Int, date: String, diary : DiaryCreateDTO)
    case deleteDiary(userID : Int, date: String)
    
    var method: HTTPMethod {
        switch self {
        case .createDiary:
            return .post
        case .getDiary:
            return .get
        case .putDiary:
            return .put
        case .patchDiary:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }
    
    var path:  String {
        switch self {
        case .createDiary:
            return "/diary-create"
        case let .getDiary(userID, date):
            return "/\(userID)/diarys/\(date)"
        case let .putDiary(userID, date, _):
            return "/\(userID)/diarys/\(date)"
        case let .patchDiary(userID, date, _):
            return "/\(userID)/diarys/\(date)"
        case let .deleteDiary(userID, date):
            return "/\(userID)/diarys/\(date)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .createDiary(diaryCreateDTO):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(diaryCreateDTO)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let parameters = jsonObject as? [String: Any] else {
                    return nil
                }
                return parameters
            } catch {
                print("Error encoding DiaryDTO: \(error)")
                return nil
            }
        case .getDiary:
            return nil
        case let .putDiary(_, _, diaryCreateDTO), let .patchDiary(_, _, diaryCreateDTO):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(diaryCreateDTO)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let parameters = jsonObject as? [String: Any] else {
                    return nil
                }
                return parameters
            } catch {
                print("Error encoding DiaryDTO: \(error)")
                return nil
            }
        case .deleteDiary:
            return nil
        }
    }
    
}
