//
//  UserTodoHeaderView.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class UserTodoHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        profileImageContainer.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
    }
    
    private lazy var statusView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.addArrangedSubview(profileImageContainer)
        stackView.addArrangedSubview(profileLabelStackView)
        return stackView
    }()
    
    private lazy var profileImageContainer: SymbolCircleView = {
        let imageView = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        imageView.setBackgroundColor(.secondarySystemFill)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var profileImage: UIImage = {
        let image = UIImage()
        return image
    }()
    
    private lazy var profileLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.addArrangedSubview(profileName)
        stackView.addArrangedSubview(profileIntro)
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.text = "test username"
        return label
    }()
    
    private lazy var profileIntro: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(statusView)
        return stackView
    }()
    
    func configure(with viewModel: UserTodoViewModel) {
        profileName.text = viewModel.username
        if let intro = viewModel.intro,
           !intro.isEmpty {
            profileIntro.text = intro
        } else {
            profileIntro.text = ""
        }
        profileImageContainer.setImage(viewModel.profilePic)
    }
    
    func configure(name: String, intro: String?, profilePic: String?) {
        profileName.text = name
        if let intro ,
           !intro.isEmpty {
            profileIntro.text = intro
        } else {
            profileIntro.text = "프로필에 자기소개를 입력해보세요"
        }
        profileImageContainer.setImage(profilePic)
    }

}
