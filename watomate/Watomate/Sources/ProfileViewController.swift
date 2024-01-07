//
//  ProfileViewController.swift
//  Watomate
//
//  Created by 이수민 on 2023/12/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
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
    
    private lazy var archiveStackView = {
        let label = UILabel()
        label.text = "보관함"
        label.font = .boldSystemFont(ofSize: 18)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(GoalStackView().withTitle(title: "sample goal 1"))
        stackView.addArrangedSubview(GoalStackView().withTitle(title: "sample goal 2"))
        stackView.addArrangedSubview(GoalStackView().withTitle(title: "sample goal 3"))
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBarItems()
        setupLayout()
    }
    
    private var usernameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private func setupTopBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: .none, action: .none)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: usernameLabel)
    }
    
    private func setupLayout() {
        profileStackView.addArrangedSubview(profileImageView)
        profileStackView.addArrangedSubview(followerStackView)
        profileStackView.addArrangedSubview(followingStackView)
        
        scrollView.addSubview(profileStackView)
        scrollView.addSubview(archiveStackView)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        profileStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.height.equalTo(60)
        }
        
        archiveStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
        }
    }
}
