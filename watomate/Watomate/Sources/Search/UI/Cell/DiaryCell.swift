//
//  DiaryCell.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class DiaryCell: UITableViewCell {
    static let reuseIdentifier = "DiaryCell"
    private var viewModel: DiaryCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10.adjusted
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var headerView = UIView()
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5.adjusted
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        return stackView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var footerView = UIView()
    
    private lazy var likeCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "heart.fill"))
        view.setBackgroundColor(.systemGray6)
        view.setSymbolColor(.systemGray4)
        return view
    }()
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.SearchDiary.containerHorizontalInset)
            make.top.bottom.equalToSuperview().inset(Constants.SearchDiary.containerVerticalInset)
        }
        
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
            make.height.equalTo(Constants.SearchDiary.headerViewHeight)
        }
        
        profileCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.headerViewHeight)
        }
        
        headerView.addSubview(profileCircleView)
        profileCircleView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        headerView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileCircleView.snp.trailing).offset(Constants.SearchDiary.offset)
        }
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.SearchDiary.offset)
            make.leading.trailing.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
        }
        
        containerView.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.SearchDiary.offset)
            make.leading.trailing.bottom.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
            make.height.equalTo(Constants.SearchDiary.footerViewHeight)
        }
        
        likeCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.footerViewHeight)
        }
        
        footerView.addSubview(likeCircleView)
        likeCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
    }
    
    func configure(with viewModel: DiaryCellViewModel) {
        self.viewModel = viewModel
        usernameLabel.text = viewModel.user.username
        dateLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
    }
    
}