//
//  TodoDetailCellView.swift
//  Watomate
//
//  Created by 권현구 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class TodoDetailCellView: UIStackView {

    private lazy var titleLabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var icon = {
        let button = UIButton()
        button.contentMode = .center
        button.tintColor = .white
        return button
    }()
    
    init() {
        super.init(frame: .init())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = 10
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addArrangedSubview(icon)
        self.addArrangedSubview(titleLabel)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(icon.snp.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.layer.cornerRadius = icon.frame.height / 2
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
