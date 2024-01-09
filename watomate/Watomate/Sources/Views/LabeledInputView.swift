//
//  LabeledInputView.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class LabeledInputView: UIView {
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    private lazy var label = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    private lazy var textField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "Pretendard-Light", size: 15)
        return textField
    }()

    init(label: String, placeholder: String?) {
        super.init(frame: .zero)
        self.label.text = label
        textField.placeholder = placeholder
        textField.setPlaceholderColor(.secondaryLabel)
        
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder(withColor: .label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(label.snp.trailing)
        }
    }
    
    private func addBottomBorder(withColor color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame  = CGRect(x: 0, y: frame.height - 0.9, width: frame.width, height: 0.9)
        bottomLine.backgroundColor = color.cgColor
        layer.addSublayer(bottomLine)
    }
    
}
