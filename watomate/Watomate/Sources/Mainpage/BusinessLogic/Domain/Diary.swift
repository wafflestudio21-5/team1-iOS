//
//  Diary.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/10.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct DiaryCreate: Codable {
    let description: String?
    let visibility: String?
    let mood: Int?
    let color: String?
    let emoji: String?
    let image: [String]?
    let created_by: Int
    let date: String
}


struct Diary: Codable{
    let id: Int
    let description: String
    let visibility : String
    let mood : Int?
    let color: String
    let emoji: String
    let image: String?
    let created_by: Int
    let date: String
    let likes: [Like]?
    let comments :[Comment]?
}


enum DiaryVisibility: String, Codable {
    case PB = "전체공개"
    case PR = "나만 보기"
    case FL = "팔로워 공개"
    
    func toString() -> String {
        switch self {
        case .PB: return "PB"
        case .PR: return "PR"
        case .FL: return "FL"
        }
    }
    
    static func from(string: String) -> DiaryVisibility? {
        switch string {
        case "PB": return .PB
        case "PR": return .PR
        case "FL": return .FL
        default: return nil
        }
    }
}

enum DiaryEmoji: String {
    case smilingFace = "😃"
    case heartEyes = "😍"
    case smilingFaceSlightly = "☺️"
    case faceHoldingBackTears = "🥲"
    case laughingWithTears = "😂"
    case partyFace = "🥳"
    case pleadingFace = "🥺"
    case cryingFace = "😭"
    case thinkingFace = "🤔"
    case smilingFaceWithHearts = "🥰"
    case dizzyFace = "😵‍💫"
    case meltingFace = "🫠"
    case sunny = "☀️"
    case partlySunny = "⛅"
    case snowman = "☃️"
    case umbrellaWithRainDrops = "☔"
    case clinkingBeerMugs = "🍻"
    case cameraWithFlash = "📸"
    case computer = "💻"
    case teddyBear = "🧸"
    case heart = "❤️"
    case twoHearts = "💗"
    case loveLetter = "💌"
}
