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
    
    private lazy var profileView = {
        let view = UserInfoView(size: .small)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        return view
    }()
    
    private lazy var commentLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 15.adjusted)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
//    private lazy var commentTextView = {
//        let textView = UITextView()
////        textView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        textView.backgroundColor = .clear
//        textView.clipsToBounds = true
//        textView.layer.cornerRadius = 22
//        textView.isScrollEnabled = false
//        textView.font = UIFont(name: Constants.Font.regular, size: 14)
//        textView.textContainerInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
////        textView.textContainer.maximumNumberOfLines = 0
//        textView.textContainer.lineBreakMode = .byCharWrapping
//        textView.textColor = .label
////        textView.delegate = self
//        textView.autocorrectionType = .no
//        textView.autocapitalizationType = .none
//        textView.isEditable = false 
//        
//        textView.snp.makeConstraints { make in
//            make.height.equalTo(41)
//        }
//        return textView
//    }()
    
    private lazy var footerView = {
        let view = LikeContainerView(size: .small)
        view.addLikeTapAction(target: self, action: #selector(likeTapped))
        return view
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(deleteButton)
        return stackView
    }()
    
    private lazy var editButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit"), for: .normal)
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func editTapped() {
        
    }
    
    private lazy var deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.width.equalTo(22)
        }
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteTapped() {
        
    }
    
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
        buttonStackView.isHidden = true
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
            make.trailing.equalToSuperview().inset(20)
        }
        
//        contentView.addSubview(commentTextView)
//        commentTextView.snp.makeConstraints { make in
//            make.top.equalTo(profileView.snp.bottom)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
        
        contentView.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.leading.equalToSuperview().offset(47.16)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with viewModel: CommentCellViewModel) {
        guard let userId = User.shared.id else { return }
        self.viewModel = viewModel
        profileView.configure(image: viewModel.profilePic, name: viewModel.username, date: viewModel.createdAt, color: viewModel.color)
//        commentLabel.text = viewModel.description
//        commentLabel.textColor = viewModel.color.label
        commentLabel.text = viewModel.description
        commentLabel.textColor = viewModel.color.label
        footerView.configure(likes: viewModel.likes, color: viewModel.color, userId: userId)
        if viewModel.user == userId {
            buttonStackView.isHidden = false
        }
    }
    
    
}

//extension CommentCell: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: commentTextView.frame.width, height: .infinity)
//           let estimatedSize = commentTextView.sizeThatFits(size)
//
//           if estimatedSize.height <= 91 { // Define maximumHeight
//               textView.isScrollEnabled = false
//               commentTextView.snp.remakeConstraints { make in
//                   make.height.equalTo(estimatedSize)
//                   make.trailing.equalToSuperview()
//                   make.leading.equalToSuperview()
//               }
//               layoutIfNeeded()
//           } else {
//               textView.isScrollEnabled = true
//           }
//    }
//}
