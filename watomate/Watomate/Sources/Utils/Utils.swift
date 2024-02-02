//
//  Utils.swift
//  Watomate
//
//  Created by 권현구 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

struct Utils {
    
    private static let formatter = DateFormatter()
    static func HHmmssFormatter() -> DateFormatter {
        formatter.timeZone = .init(identifier: "Asia/Seoul")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    static func aHmmFormatter() -> DateFormatter {
        formatter.timeZone = .init(identifier: "Asia/Seoul")
        formatter.dateFormat = "a H:mm"
        return formatter
    }
    
    static func YYYYMMddFormatter() -> DateFormatter {
        formatter.timeZone = .init(identifier: "Asia/Seoul")
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    
    static func convertToShortKorean(date: String) -> String {
        let stringFormat = "yyyy-MM-dd"
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")
        guard let tempDate = formatter.date(from: date) else {
                   return ""
        }
        formatter.dateFormat = "MMM d일"
        return formatter.string(from: tempDate)
        
    }
    
    static func convertToKorean(date: String) -> String {
        let stringFormat = "yyyy-MM-dd"
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")
        guard let tempDate = formatter.date(from: date) else {
                   return ""
        }
        formatter.dateFormat = "yy년 MMM d일"
        return formatter.string(from: tempDate)
        
    }
    

    static func getTodayString() -> String {
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 MMM d일"
        return formatter.string(from: Date())

    static func getTodayYYYYMMdd() -> String {
        return YYYYMMddFormatter().string(from: Date())
    }
    
    static func getDateOfToday() -> Date {
        return YYYYMMddFormatter().date(from: getTodayYYYYMMdd())!

    }
}
