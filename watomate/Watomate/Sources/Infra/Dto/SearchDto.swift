//
//  SearchDto.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct AllUsersResponseDto: Decodable {
    let next, previous: String?
    let results: [UserDto]
    
    func toDomain() -> UsersPage {
        return .init(nextUrl: next,
                     results: results.map{ $0.toDomain() })
    }
    
}

extension AllUsersResponseDto {
    struct UserDto: Decodable {
        let user: Int
        let intro: String?
        let username: String
        let profilePic: String?
        
        func toDomain() -> UserInfo {
            return .init(id: user,
                         intro: intro,
                         username: username,
                         profilePic: profilePic)
        }
    }
}
