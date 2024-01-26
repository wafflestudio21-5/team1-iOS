//
//  DiaryRepository.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/25.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

protocol DiaryRepositoryProtocol {
    func createDiary(diary: DiaryCreateDTO) async throws //post
    func getDiary(userID : Int, date: String) async throws -> Diary
    // func putDiary(userID : Int, date: String, diary : DiaryDTO) // put = 안 바꾼 값에 대해선 Null
    func patchDiary(userID : Int, date: String, diary : DiaryCreateDTO) async throws
    // func deleteDiary(userID : Int, date: String)
}

class DiaryRepository: DiaryRepositoryProtocol {
    private let session = NetworkManager.shared.session
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func createDiary(diary: DiaryCreateDTO) async throws{
       try await session
            .request(DiaryRouter.createDiary(diary: diary))
            .validate()
            .serializingDecodable(DiaryCreateDTO.self, decoder: decoder)
            .handlingError()
        
        
    }
    
    func getDiary(userID: Int, date: String) async throws -> Diary {
        let dto = try await session
            .request(DiaryRouter.getDiary(userID: userID, date: date))
            .validate()
            .serializingDecodable(DiaryDTO.self, decoder: decoder)
            .handlingError()
        return dto.toDomain()
    }
    
    func patchDiary(userID: Int, date: String, diary: DiaryCreateDTO) async throws{
        let dto = try await session
            .request(DiaryRouter.patchDiary(userID: userID, date: date, diary: diary))
            .validate()
            .serializingDecodable(DiaryCreateDTO.self, decoder: decoder)
            .handlingError()
    }
    
    
}
