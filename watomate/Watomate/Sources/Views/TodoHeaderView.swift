//
//  TodoHeaderView.swift
//  Watomate
//
//  Created by 권현구 on 1/13/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class TodoHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "TodoHeaderView"

    lazy var goalView = {
        let goalView = GoalStackView()
        goalView.setTitleFont(font: .boldSystemFont(ofSize: 18))
        return goalView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(goalView)
        goalView.translatesAutoresizingMaskIntoConstraints = false
        goalView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
    func setTitle(with title: String) {
        self.goalView.setTitle(with: title)
    }
}

class ProfileHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "ProfileHeaderView"

    private lazy var profileImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemFill
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var followerStackView = {
        let followerNumLabel = UILabel()
        followerNumLabel.text = "0"
        followerNumLabel.font = UIFont.boldSystemFont(ofSize: 20)
        followerNumLabel.textAlignment = .center
        followerNumLabel.sizeToFit()
        followerNumLabel.translatesAutoresizingMaskIntoConstraints = false
        let followerLabel = UILabel()
        followerLabel.text = "팔로워"
        followerLabel.font = UIFont.systemFont(ofSize: 12)
        followerLabel.textAlignment = .center
        followerLabel.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [followerNumLabel, followerLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var followingStackView = {
        let followingNumLabel = UILabel()
        followingNumLabel.text = "0"
        followingNumLabel.font = UIFont.boldSystemFont(ofSize: 20)
        followingNumLabel.textAlignment = .center
        followingNumLabel.translatesAutoresizingMaskIntoConstraints = false
        let followingLabel = UILabel()
        followingLabel.text = "팔로잉"
        followingLabel.font = UIFont.systemFont(ofSize: 12)
        followingLabel.textAlignment = .center
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [followingNumLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var profileStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var archiveLabel = {
        let label = UILabel()
        label.text = "보관함"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        profileStackView.addArrangedSubview(profileImageView)
        profileStackView.addArrangedSubview(followerStackView)
        profileStackView.addArrangedSubview(followingStackView)

        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.spacing = 30
        headerStackView.alignment = .leading
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.addArrangedSubview(profileStackView)
        headerStackView.addArrangedSubview(archiveLabel)

        
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
