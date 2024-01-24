//
//  CGFloat+Extensions.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 667
        return self * ratio
    }
}

extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height /  667)
        return self * ratio
    }
}
