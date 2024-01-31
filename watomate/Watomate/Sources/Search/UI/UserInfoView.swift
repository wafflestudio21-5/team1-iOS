//
//  UserInfoView.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

enum UserInfoSize {
    case regular
    case small
}

class UserInfoView: UIView {
    private let size: UserInfoSize
    
    private lazy var headerView = {
       let view = UIView()
        
        profileCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(size == .regular ? Constants.SearchDiary.headerViewHeight : Constants.SearchDiary.headerViewHeight - 5.adjusted)
        }
        
        view.addSubview(profileCircleView)
        profileCircleView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileCircleView.snp.trailing).offset(size == .regular ? Constants.SearchDiary.offset : Constants.SearchDiary.offset - 3.adjusted)
        }
        
        return view
    }()
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = size == .regular ? 5.adjusted : 3.adjusted
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        return stackView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.semiBold, size: size == .regular ? 16.adjusted : 14.adjusted)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont(name: Constants.Font.regular, size: size == .regular ? 13.adjusted : 11.adjusted)
        return label
    }()
    
    init(size: UserInfoSize) {
        self.size = size
        super.init(frame: .zero)
        
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String?, name: String, date: String, color: Color) {
        if let image {
            profileCircleView.setImage(image)
        } else {
            profileCircleView.setDefault()
        }
        usernameLabel.text = name
        dateLabel.text = date 
        
        usernameLabel.textColor = color.label
        dateLabel.textColor = color.secondaryLabel
    }
    
    func reset() {
        profileCircleView.reset()
        usernameLabel.text = nil
        dateLabel.text = nil
    }
    
}
