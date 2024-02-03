//
//  TodoHeaderView.swift
//  Watomate
//
//  Created by 권현구 on 1/13/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class TodoHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "TodoHeaderView"
    /*
    let userID = User.shared.id
    var followingCount : Int = 0
    var followerCount: Int = 0
    var viewModel = FollowCountViewModel(useCase: SearchUseCase(searchRepository: SearchRepository()))
    
    private func fetchFollowCount(userId: Int) {
        Task {
            do {
                let userInfo = try await viewModel.getUserInfo(id: userId)
                DispatchQueue.main.async {
                    self.followerCount = userInfo.followerCount ?? User.shared.followerCount!
                    self.followingCount = userInfo.followingCount ?? User.shared.followingCount!
                }
            } catch {
                print("An error occurred: \(error)")
            }
        }
    }
     */
    
    lazy var goalView = {
        let goalView = GoalStackView()
        goalView.setTitleFont(font: .boldSystemFont(ofSize: 18))
        return goalView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // fetchFollowCount(userId: userID!)
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
    
    func setColor(with color: Color) {
        self.goalView.setColor(color: color)
    }
    
    func setVisibility(with visibility: Visibility) {
        self.goalView.setVisibility(visibility: visibility)
    }
    
}

class ProfileHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "ProfileHeaderView"

    private lazy var profileImageView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.secondarySystemFill)
        return view
    }()
    
    private lazy var followerCountLabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followerStackView = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [followerCountLabel, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var followingCountLabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followingStackView = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [followingCountLabel, label])
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
    
    private lazy var archiveBoxButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
       let imageView = UIImageView(image: UIImage(systemName: "archivebox.circle.fill"))
        imageView.tintColor = .black
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(26)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        let label = UILabel()
        label.text = "나의 인증샷"
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 12)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        return button
    }()
    
    private lazy var topProfileView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        topProfileView.addSubview(profileStackView)
        topProfileView.addSubview(archiveBoxButton)
        profileStackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        archiveBoxButton.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(68)
            make.trailing.equalToSuperview()
        }
        
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.spacing = 30
        headerStackView.alignment = .fill
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.addArrangedSubview(topProfileView)
        headerStackView.addArrangedSubview(archiveLabel)

        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func addProfileTapEvent(target: Any?, action: Selector?) {
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        profileImageView.addGestureRecognizer(gestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    func archiveBoxTapEvent(target: Any?, action: Selector?) {
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        archiveBoxButton.addGestureRecognizer(gestureRecognizer)
        archiveBoxButton.isUserInteractionEnabled = true
    }
}

extension ProfileHeaderView {
    func setProfileImage(with image: UIImage?) {
        guard let img = image else {
            profileImageView.setProfileImage()
            return
        }
        profileImageView.image = image
    }
    
    func setFollowerCount(count : Int) {
        followerCountLabel.text = "\(count)"
    }
    
    func setFollowingCount(count: Int) {
        followingCountLabel.text = "\(count)"
    }
    
}
