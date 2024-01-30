//
//  DiaryCreateService.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/10.
//  Copyright © 2024 tuist.io. All rights reserved.
//
  

import Foundation
import Alamofire

struct DiaryCreateService{
    static let shared = DiaryCreateService()
 
    func createDiary(entry: DiaryCreate, completion: @escaping (NetworkResult<Any>) -> Void){
        let diaryCreateUrl = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/diary-create"
        let token = "f9f1b1dd9de499b445077473d45760fdb7e99447"
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token \(token)"]
        let parameters: Parameters = [
            "description": entry.description ?? "no context",
            "visibility": entry.visibility ?? "PB",
            "mood": entry.mood ?? nil,
            "color": entry.color ?? "system",
            "emoji": entry.emoji ?? "no emoji",
            "image": entry.image ?? nil,
            "created_by": entry.created_by,
            "date": entry.date
        ]
        
        let dataRequest = AF.request(diaryCreateUrl,
                                     method: .post,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeDiaryCreateStatus(by: statusCode, value)
                completion(networkResult)
                print(value)
            case .failure(let error):
                print("Alamofire Error: \(error)")
                completion(.pathErr)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeDiaryCreateStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
       switch statusCode {
       case 201: return .success(data)
       case 400: return .pathErr
       case 500: return .serverErr
       default: return .networkFail
       }
    }
    
    func patchDiary(userID: Int, date: String, entry: DiaryCreate, completion: @escaping (NetworkResult<Any>) -> Void){
        let diaryUrl = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(userID)/diarys/\(date)"
        
        let token = "f9f1b1dd9de499b445077473d45760fdb7e99447"
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token \(token)"]
        
        let parameters: Parameters = [
            "description": entry.description,
            "visibility": entry.visibility,
            "mood": entry.mood,
            "color": entry.color,
            "emoji": entry.emoji,
            "image": entry.image,
            "created_by": entry.created_by,
            "date": entry.date
        ]
        /*
        {
          "description": [
            "This field may not be null."
          ],
          "visibility": [
            "This field may not be null."
          ],
          "color": [
            "This field may not be null."
          ],
          "emoji": [
            "This field may not be null."
          ]
        }
         */

        let dataRequest = AF.request(diaryUrl,
                                     method: .patch,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeDiaryPatchStatus(by: statusCode, value)
                completion(networkResult)
                print(value)
            case .failure(let error):
                print("Alamofire Error: \(error)")
                completion(.pathErr)
                completion(.networkFail)
            }
        }
        
    }
    
    private func judgeDiaryPatchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
       switch statusCode {
       case 200: return .success(data)
       case 400: return .pathErr
       case 500: return .serverErr
       default: return .networkFail
       }
    }
    
}

