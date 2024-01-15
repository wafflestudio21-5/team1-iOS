//
//  AuthDto.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct SignupResponseDto: Codable {
    let resultCode: Int
    let token: String
    let userId: Int
}
