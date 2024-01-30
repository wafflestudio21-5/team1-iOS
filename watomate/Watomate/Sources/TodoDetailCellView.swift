//
//  TodoDetailCellView.swift
//  Watomate
//
//  Created by 권현구 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class TodoDetailCellView: UIStackView {
    var delegate: UITextFieldDelegate?
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var icon = {
        let button = UIButton()
        button.contentMode = .center
        button.tintColor = .white
        return button
    }()
    
    private lazy var deleteButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isHidden = true
        return button
    }()
    
    private lazy var doneButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isHidden = true
        return button
    }()
    
    init() {
        super.init(frame: .init())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = 10
        self.distribution = .fill
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addArrangedSubview(icon)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(deleteButton)
        self.addArrangedSubview(doneButton)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
            if let view = superview {
                make.width.equalTo(view.snp.width)
            }
        }
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(icon.snp.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.layer.cornerRadius = icon.frame.height / 2
    }
    
    func showDoneBtn() {
        doneButton.isHidden = false
    }
    
    func showDeleteBtn() {
        deleteButton.isHidden = false
    }
    
    func addDoneBtnTarget(_ target: Any?, action: Selector, event: UIControl.Event) {
        doneButton.addTarget(target, action: action, for: event)
    }
    
    func addDeleteBtnTarget(_ target: Any?, action: Selector, event: UIControl.Event) {
        deleteButton.addTarget(target, action: action, for: event)
    }
}

extension TodoDetailCellView {
    func setIconBackgroundColor(_ color: UIColor) {
        icon.backgroundColor = color
    }
    
    func setIcon(_ iconImage: UIImage) {
        icon.setImage(iconImage, for: .normal)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
