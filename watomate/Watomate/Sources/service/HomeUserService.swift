//
//  HomeUserInfoService.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/30.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Alamofire

struct HomeUserService{
    static let shared = HomeUserService()

    func getHomeUser(userID : Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let token = "f9f1b1dd9de499b445077473d45760fdb7e99447"
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token \(token)"]
        
        let getHomeUserUrl = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(userID)"
        
        let dataRequest = AF.request(getHomeUserUrl,
                                     method: .get,
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
        case 200: return isValidData(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
            
        } // 서버의 에러 메세지에 따라 달라짐 !!!!!!
    }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        do {
            print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
            let decodedData = try decoder.decode(HomeUser.self, from: data)
            return .success(decodedData)
        } catch {
            print("Decoding error: \(error)")
            return .pathErr
        }
    }
}
