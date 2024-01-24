//
//  UserHeaderView.swift
//  Watomate
//
//  Created by 이지현 on 1/25/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class UserHeaderView: UIView {
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 16)
        return label
    }()
    
    init(username: String) {
        super.init(frame: .zero)
        usernameLabel.text = username
        backgroundColor = .systemBackground

        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(profileCircleView)
        addSubview(usernameLabel)
        
        profileCircleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(35)
            make.leading.equalToSuperview().offset(20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileCircleView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}

