//
//  UITextField+Extensions.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UITextField {
    func addBottomBorder(withColor color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.name = "bottomBorder"
        bottomLine.frame  = CGRect(x: 0, y: frame.height - 0.9, width: frame.width, height: 0.9)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func updateBottomBorder(withColor color: UIColor) {
        layer.sublayers?.removeAll(where: { $0.name == "bottomBorder" })
        let bottomLine = CALayer()
        bottomLine.frame  = CGRect(x: 0, y: frame.height - 0.9, width: frame.width, height: 0.9) 
        bottomLine.backgroundColor = color.cgColor
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
