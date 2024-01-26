//
//  UserRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol UserRepositoryProtocol {
    func changeProfilePic(id: Int, imageData: Data?) async throws
    func changeUserInfo(id: Int, username: String, intro: String) async throws
}

class UserRepository: UserRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func changeProfilePic(id: Int, imageData: Data?) async throws {
        guard let imageData else { return }
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token f9f1b1dd9de499b445077473d45760fdb7e99447"
        ]
        
        let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(id)"
        
        try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "profile_pic", fileName: "profile_pic.png", mimeType: "image/png")
        }, to: url, method: .patch, headers: header)
        .serializingDecodable(UserDto.self, decoder: decoder).handlingError()
    }
    
    func changeUserInfo(id: Int, username: String, intro: String) async throws {
        try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(username.data(using: .utf8)!, withName: "username")
            multipartFormData.append(intro.data(using: .utf8)!, withName: "intro")
        }, with: UserRouter.changeUserInfo(id: id))
        .serializingDecodable(UserDto.self, decoder: decoder).handlingError()
    }
    
    func signupWithEmail(email: String, password: String) async throws -> LoginInfo {
        let dto = try await session.request(AuthRouter.signupWithEmail(email: email, password: password))
            .serializingDecodable(LoginResponseDto.self, decoder: decoder).handlingError()
        return dto.toDomain()
    }
}

//private func handleImage(_ image: UIImage?) {
//    guard let id = User.shared.id else { return }
//    let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(id)"
//    print(id)
//    
//    let header: HTTPHeaders = [
//        "Content-Type" : "multipart/form-data",
//        "Authorization" : "Token " + (User.shared.token ?? "")
//    ]
//    let parameters: [String: Any?] = [
//        "username" : "test"
//    ]
//    
//    AF.upload(multipartFormData: { multipartFormData in
//        for (key, value) in parameters {
//                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//                    }
//        if let image = image?.pngData() {
//            multipartFormData.append(image, withName: "profile_pic", fileName: "\(image).png", mimeType: "image/png")
//        }
//    }, to: url, usingThreshold: UInt64.init(), method: .patch, headers: header).responseJSON { response in
//        switch response.result {
//        case .success(let data):
//            print(response.response?.statusCode)
//            print(data)
//        case .failure(let error):
//            print(error)
//        }
//    }
//}
