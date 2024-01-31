//
//  CommentCell.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    static let reuseIdentifier = "commentCell"
    private var viewModel: CommentCellViewModel?
    
    private lazy var profileView = UserInfoView(size: .small)
    
    private lazy var commentLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 15.adjusted)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var footerView = {
        let view = LikeContainerView(size: .small)
        view.addLikeTapAction(target: self, action: #selector(likeTapped))
        return view
    }()
    
    @objc func likeTapped() {
//        if let viewModel,
//           let delegate,
//        let userId = User.shared.id  {
//            delegate.selectEmoji(diaryId: viewModel.diaryId, userId: userId)
//        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileView.reset()
        commentLabel.text = nil
        footerView.reset()
    }
    
    private func setupLayout() {
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(5.adjustedH)
            make.leading.equalToSuperview().offset(47.16)
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(5.adjustedH)
            make.leading.equalToSuperview().offset(47.16)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with viewModel: CommentCellViewModel) {
        guard let userId = User.shared.id else { return }
        self.viewModel = viewModel
        profileView.configure(image: viewModel.profilePic, name: viewModel.username, date: viewModel.createdAt, color: viewModel.color)
        commentLabel.text = viewModel.description
        commentLabel.textColor = viewModel.color.label
        footerView.configure(likes: viewModel.likes, color: viewModel.color, userId: userId)
    }
    
    
}
