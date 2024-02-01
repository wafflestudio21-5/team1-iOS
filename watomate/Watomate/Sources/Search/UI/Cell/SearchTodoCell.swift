//
//  SearchTodoCell.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class SearchTodoCell: UITableViewCell {
    static let reuseIdentifier = "SearchTodoCell"
    private var viewModel: SearchTodoCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        completeView.reset()
    }
    
    private lazy var containerView = UIView()
    
    private lazy var completeView = CustomSymbolView(size: 20)
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 15)
        return label
    }()
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(completeView)
        completeView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(9)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(completeView)
        }
    }
    
    func configure(with viewModel: SearchTodoCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        if viewModel.isCompleted {
            completeView.setColor(color: [Color(rawValue: viewModel.color) ?? Color.gray])
            completeView.addCheckMark()
        } else {
            completeView.setColor(color: [])
        }
        
    }
    
}
