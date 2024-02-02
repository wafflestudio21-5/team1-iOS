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
            return .systemGray4
        default:
            return UIColor(named: self.rawValue) ?? .systemBackground
        }
    }
    
    var label: UIColor {
        switch self {
        case .system:
            return .label
        case .beige, .lightblue, .lime, .pink, .yellow:
            return .darkGray
        default:
            return .white 
        }
    }
    
    var secondaryLabel: UIColor {
        switch self {
        case .system:
            return .secondaryLabel
        case .beige, .lightblue, .lime, .pink, .yellow:
            return .secondaryLabel
        default:
            return .white
        }
    }
    
    var heartBackground: UIColor {
        switch self {
        case .system:
            return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        default:
            return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        }
    }
    
    var heartSymbol: UIColor {
        switch self {
        case .system:
            return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        default:
            return self.uiColor.withAlphaComponent(0.9)
        }
    }
    
}



