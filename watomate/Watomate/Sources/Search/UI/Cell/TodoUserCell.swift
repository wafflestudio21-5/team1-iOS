//
//  TodoUserCell.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class TodoUserCell: UITableViewCell {
    static let reuseIdentifier = "TodoUserCell"
    private var viewModel: TodoUserCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private func setupLayout() {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(with viewModel: TodoUserCellViewModel) {
        self.viewModel = viewModel
        usernameLabel.text = viewModel.username
    }
}
