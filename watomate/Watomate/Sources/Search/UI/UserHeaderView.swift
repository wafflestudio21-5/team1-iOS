//
//  UserHeaderView.swift
//  Watomate
//
//  Created by 이지현 on 1/25/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class UserHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "userHeader"
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        view.setSymbolColor(.white)
        return view
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 18)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        usernameLabel.text = nil
        profileCircleView.reset()
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
    
    func configure(username: String, profilePic: String?) {
        usernameLabel.text = username
        if let profilePic {
            profileCircleView.setImage(profilePic)
        }
    }
}

