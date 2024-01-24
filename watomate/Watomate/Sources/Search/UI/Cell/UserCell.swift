//
//  UserCell.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class UserCell: UITableViewCell {
    static let reuseIdentifier = "UserCell"
    private var viewModel: UserCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var profileView = CustomSymbolView(size: Constants.SearchUser.profileHeight)
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 18)
        return label
    }()
    
    private lazy var introLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont(name: Constants.Font.regular, size: 14)
        return label
    }()
    
    private func setupLayout() {
        addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchUser.profileHeight)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.SearchUser.contentsInset)
        }
        
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(Constants.SearchUser.offset)
            make.top.trailing.equalToSuperview().inset(Constants.SearchUser.contentsInset)
        }
        
        addSubview(introLabel)
        introLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(Constants.SearchUser.offset)
            make.top.equalTo(usernameLabel.snp.bottom).offset(5.adjusted)
            make.trailing.bottom.equalToSuperview().inset(Constants.SearchUser.contentsInset)
        }
        
    }
    
    func configure(with viewModel: UserCellViewModel) {
        self.viewModel = viewModel
        usernameLabel.text = viewModel.username
        introLabel.text = viewModel.intro
        profileView.setColor(color: viewModel.color)
        profileView.addDefaultImage()
    }
}