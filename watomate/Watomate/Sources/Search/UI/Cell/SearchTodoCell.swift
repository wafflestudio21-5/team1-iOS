//
//  SearchTodoCell.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

class SearchTodoCell: UITableViewCell {
    
}

//class TodoCell: UITableViewCell {
//    static let reuseIdentifier = "TodoCell"
//    private var viewModel: TodoCellViewModel?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private lazy var usernameLabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        return label
//    }()
//    
//    private lazy var introLabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        return label
//    }()
//    
//    private func setupLayout() {
//        addSubview(usernameLabel)
//        usernameLabel.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview().inset(10)
//        }
//        
//        addSubview(introLabel)
//        introLabel.snp.makeConstraints { make in
//            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
//            make.leading.trailing.bottom.equalToSuperview().inset(10)
//        }
//        
//    }
//    
//    func configure(with viewModel: UserCellViewModel) {
//        self.viewModel = viewModel
//        usernameLabel.text = viewModel.username
//        introLabel.text = viewModel.intro
//    }
//}
