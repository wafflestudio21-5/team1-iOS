//
//  HomeUSer.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/30.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import UIKit

struct HomeUser: Codable{
    let user : Int
    let tedoori: Bool
    let intro: String
    let username: String
    let profile_pic: String
}

enum ProfileImageConstant {
    static let thumbnailSize = 50.0
    static let thumbnailCGSize = CGSize(width: 100, height: 100)
    static let spacing = 4.0
}

enum TedooriConstants {
    static let innerBorderWidth: CGFloat = 1.5
    static let outerBorderWidth: CGFloat = 1.5
    static let innerBorderColor: UIColor = .white
    static let outerBorderColor: UIColor = .black
}
