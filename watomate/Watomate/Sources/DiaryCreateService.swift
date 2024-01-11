//
//  DiaryCreateService.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/10.
//  Copyright © 2024 tuist.io. All rights reserved.
//
  

import Foundation
import Alamofire

// 현재 작동하지 않음
struct DiaryCreateService{
    static let shared = DiaryCreateService()
    let vc = DiaryCreateViewController()
    let api = APIConstants()
    
    private func makeParameter(diaryText: String?, date: String?) -> Parameters //입력값 넣을수도
    {
        return [ "description": diaryText ?? "no context" ,
                  "visibility": "PB",
                 "mood": 100,
                 "color": "string",
                 "emoji": 10,
                // "image": "string", //이미지 x
                 "created_by": 1, //유저 아이디 정보 아직 x
                 "date": date ?? "no date"]
    }
    
    func createDiary(diaryText: String?, date: String?, completion: @escaping (NetworkResult<Any>) -> Void){
        let header : HTTPHeaders = ["Content-Type": "application/json", "Accept":"application/json"]
        
        let dataRequest = AF.request(api.diaryURL,
                                     method: .post,
                                     parameters: makeParameter(diaryText: diaryText, date: date),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
                    
            // dataResponse가 도착했으니, 그 안에는 통신에 대한 결과물이 있다
            // dataResponse.result는 통신 성공했는지 / 실패했는지 여부
            switch dataResponse.result {
            
            // dataResponse가 성공이면 statusCode와 response(결과데이터)를 guard let 구문을 통해서 저장해 둡니다.
            case .success:
                // dataResponse.statusCode는 Response의 statusCode - 200/400/500
                guard let statusCode = dataResponse.response?.statusCode else {return}
                // dataResponse.value는 Response의 결과 데이터
                guard let value = dataResponse.value else { return }
                
                // judgeStatus라는 함수에 statusCode와 response(결과데이터)를 실어서 보냅니다.
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
             
            // 통신 실패의 경우, completion에 pathErr값을 담아서 뷰컨으로 날려줍니다.
            // 타임아웃 / 통신 불가능의 상태로 통신 자체에 실패한 경우입니다.
            case .failure: completion(.pathErr)
        }
                    
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
       switch statusCode {
       case 200: return .success((Any).self) // 성공 -> 데이터를 가공해서 전달해줘야 하기 때문에 isValidData라는 함수로 데이터 넘격줌
       case 400: return .pathErr // -> 요청이 잘못됨
       case 500: return .serverErr // -> 서버 에러
       default: return .networkFail // -> 네트워크 에러로 분기 처리할 예정
           
       }
   }
    
}
