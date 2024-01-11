//
//  UITextField+Extensions.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame  = CGRect(x: 0, y: frame.height - 0.9, width: frame.width, height: 0.9)
        bottomLine.backgroundColor = UIColor.systemGray3.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
