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
    func changeProfilePic(id: Int, imageData: Data?) async throws -> String?
    func changeUserInfo(id: Int, username: String, intro: String) async throws
    
    func imageUpload(todoId: Int, imageData: Data?) async throws -> String?
    func getAllImage() async throws -> AllImageResponseDto
}

class UserRepository: UserRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func changeProfilePic(id: Int, imageData: Data?) async throws -> String? {
        guard let imageData else { return nil }
        guard let token = User.shared.token else { return nil }
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token \(token)"
        ]
        
        let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(id)"
        
        let dto = try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "profile_pic", fileName: "profile_pic.png", mimeType: "image/png")
        }, to: url, method: .patch, headers: header)
        .serializingDecodable(UserInfoDto.self, decoder: decoder).handlingError()
        return dto.profilePic
    }
    
    func changeUserInfo(id: Int, username: String, intro: String) async throws {
        
        guard let token = User.shared.token else { return }
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token \(token)"
        ]
        
        let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/\(id)"
        
        try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(username.data(using: .utf8)!, withName: "username")
            multipartFormData.append(intro.data(using: .utf8)!, withName: "intro")
        }, to: url, method: .patch, headers: header)
        .serializingDecodable(UserInfoDto.self, decoder: decoder).handlingError()
    }
    
    @discardableResult
    func imageUpload(todoId: Int, imageData: Data?) async throws -> String? {
        guard let imageData else { return nil }
        guard let token = User.shared.token else { return nil }
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token \(token)"
        ]
        
        let url = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api/image-upload/\(todoId)"
        
        let dto = try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
        }, to: url, method: .put, headers: header)
        .serializingDecodable(ImageUploadResponseDto.self, decoder: decoder).handlingError()
        return dto.image
    }
    
    func getAllImage() async throws -> AllImageResponseDto {
        return try await session.request(UserRouter.getAllImage).serializingDecodable(AllImageResponseDto.self, decoder: decoder).handlingError()
    }
    
}

