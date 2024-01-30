//
//  Color.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum Color: String {
    case beige
    case blue
    case brown
    case coffee
    case lightblue
    case lime
    case orange
    case red
    case pink
    case purple
    case green
    case yellow
    case gray
    case system
    
    var uiColor: UIColor {
        switch self {
        case .system:
            return .systemBackground
        case .gray:
            return .systemGray5
        default:
            return UIColor(named: self.rawValue) ?? .systemBackground
        }
    }
}



