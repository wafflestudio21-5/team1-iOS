//
//  HomeUSer.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/30.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct HomeUser: Codable{
    let user : Int
    let tedoori: Bool
    let intro: String
    let username: String
    let profile_pic: String
}
