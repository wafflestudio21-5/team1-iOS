//
//  Constants.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

enum Constants {
    enum Font {
        static let black = "Pretendard-Black"
        static let extraBold = "Pretendard-ExtraBold"
        static let bold = "Pretendard-Bold"
        static let semiBold = "Pretendard-SemiBold"
        static let medium = "Pretendard-Medium"
        static let regular = "Pretendard-Regular"
        static let light = "Pretendard-Light"
        static let extraLight = "Pretendard-ExtraLight"
        static let thin = "Pretendard-Thin"
        
    }
    
    enum First {
        static let horizontalInset = 35.0.adjusted
        static let imageViewSize = 200.0.adjusted
        static let titleFontSize = 36.0.adjusted
        static let subtitleFontSize = 14.0.adjusted
        static let bottomInset = 30.0.adjusted
        static let buttonHeight = 38.0.adjusted
        static let buttonFontSize = 14.0.adjusted
    }
    enum Login {
        static let topInset = 12.0.adjusted
        static let horizontalInset = 35.0.adjusted
        static let textFieldHeight = 50.0.adjusted
        static let textFieldFontSize = 17.0.adjusted
        static let buttonHeight = 45.0.adjusted
        static let buttonFontSize = 16.0.adjusted
        static let infoFontSize = 14.0.adjusted
    }
    enum SearchDiary {
        static let containerHorizontalInset = 20.0.adjusted
        static let containerVerticalInset = 10.0.adjusted
        static let contentsInset = 15.0.adjusted
        static let offset = 11.0.adjusted
        static let headerViewHeight = 40.0.adjusted
        static let footerViewHeight = 25.0.adjusted
    }
    
    enum SearchUser {
        static let contentsInset = 15.0.adjusted
        static let offset = 20.0.adjusted
        static let profileHeight = 45.adjusted
    }
}
