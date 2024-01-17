//
//  CustomButton.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    private let title: String
    private let titleSize: CGFloat
    private var titleColor: UIColor = .label {
        didSet{
            configuration?.baseForegroundColor = titleColor
        }
    }
    private var baseColor: UIColor = .systemGray6 {
        didSet{
            configuration?.baseBackgroundColor = baseColor
        }
    }
    private var borderColor: UIColor? = nil
    
    init(title: String, titleSize: CGFloat) {
        self.title = title
        self.titleSize = titleSize
        super.init(frame: .zero)
        
        configure()
    }
    
    private func configure() {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Regular", size: titleSize)
        
        configuration = .filled()
        configuration?.baseForegroundColor = titleColor
        configuration?.baseBackgroundColor = baseColor
        configuration?.attributedTitle = AttributedString(title, attributes: titleContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(backgroundColor: UIColor, titleColor: UIColor) {
        baseColor = backgroundColor
        self.titleColor = titleColor
    }
    
    func setColor(titleColor: UIColor) {
        self.titleColor = titleColor
    }
    
    func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
    }
    
}
