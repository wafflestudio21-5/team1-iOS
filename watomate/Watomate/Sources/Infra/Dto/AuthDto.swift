//
//  AuthDto.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct LoginResponseDto: Decodable {
    let resultCode: Int
    let token: String
    let userId: Int
    
    func toDomain() -> LoginInfo {
        return LoginInfo(id: userId, token: token)
    }
}

struct GuestResponseDto: Decodable {
    let token: String
    let userId: Int
    
    func toDomain() -> LoginInfo {
        return LoginInfo(id: userId, token: token)
    }
}

