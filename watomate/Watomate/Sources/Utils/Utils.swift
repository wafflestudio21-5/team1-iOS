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
}
