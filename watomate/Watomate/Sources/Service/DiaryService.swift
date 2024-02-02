//
//  DiaryService.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//


import Foundation
import Alamofire

struct DiaryService{
    static let shared = DiaryService()
    
    func getDiary(userID : Int, date : String, completion: @escaping (NetworkResult<Any>) -> Void){
        guard let token = User.shared.token else { return }
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token \(token)"]
        let diaryUrl = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(userID)/diarys/\(date)"

        let dataRequest = AF.request(diaryUrl,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            // dataResponse가 도착 -> 안에는 통신에 대한 결과물
            // dataResponse.result = 통신 성공/실패 여부
            switch dataResponse.result {
            
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                // dataResponse.value: Response의 결과 데이터
                guard let value = dataResponse.value else { return }
                
                // judgeStatus라는 함수에 statusCode와 response(결과데이터)를 실어서 전송
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
             
            // 통신 실패의 경우, completion에 pathErr값을 담아서 VC으로 날려줍니다.
            // 타임아웃 -  통신 자체에 실패
            case .failure: completion(.pathErr)
        }
                    
        }
    }
    
    func deleteDiary(userID : Int, date : String, completion: @escaping (NetworkResult<Any>) -> Void){
        guard let token = User.shared.token else { return }
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token \(token)"]
        let diaryUrl = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(userID)/diarys/\(date)"
        let dataRequest = AF.request(diaryUrl,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
                
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
       switch statusCode {
       case 200: return isValidData(data: data) // 성공 -> 데이터를 가공해서 전달해줘야 하기 때문에 isValidData라는 함수로 데이터 넘겨줌
       case 400: return .pathErr // -> 요청이 잘못됨
       case 500: return .serverErr // -> 서버 에러
       default: return .networkFail // -> 네트워크 에러로 분기 처리 예정
           
       } // 서버의 에러 메세지에 따라 달라짐 !!!!!!
   }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        do {
            print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
            let decodedData = try decoder.decode(Diary.self, from: data)
            return .success(decodedData)
        } catch {
            print("Decoding error: \(error)")
            return .pathErr
        }
    }
    
    
    
    /*
    private func makeParameter(diaryText: String?, date: String?) -> Parameters
    {
        return [ "description": diaryText ?? "no context" ,
                 "visibility": "PB",
                 "mood": 100,
                 "color": "string",
                 "emoji": 10,
                // "image": "string", //이미지 x
                 "created_by": 1, //유저 아이디 정보 아직 x
                 "date": "2024-02-03"]  //date ?? "no date"
    }
    
    
    func patchDiary(diaryText: String?, date: String?, completion: @escaping (NetworkResult<Any>) -> Void){
        let header : HTTPHeaders = ["Content-Type": "application/json", "Accept":"application/json"]
        let parameters = makeParameter(diaryText: diaryText, date: date)
        
        let dataRequest = AF.request(api.diaryURL,
                                     method: .patch,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
        }
                    
        }
        
    }*/
    
}

