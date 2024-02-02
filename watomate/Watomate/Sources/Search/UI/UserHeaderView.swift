//
//  UserHeaderView.swift
//  Watomate
//
//  Created by 이지현 on 1/25/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class UserHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "userHeader"
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        view.setSymbolColor(.white)
        return view
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 16)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        usernameLabel.text = nil
        profileCircleView.reset()
    }
    
    private func setupLayout() {
        addSubview(profileCircleView)
        addSubview(usernameLabel)
        
        profileCircleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.width.height.equalTo(33)
            make.leading.equalToSuperview().offset(20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileCircleView.snp.trailing).offset(9)
            make.centerY.equalToSuperview()
        }
    }
    
    var sendingInfo : SendingInfo?
    func configure(id: UUID, username: String, profilePic: String?, intro: String?, tedoori: Bool) {
        usernameLabel.text = username
        if let profilePic {
            profileCircleView.setImage(profilePic)
        } else {
            profileCircleView.setDefault()
        }
        sendingInfo = SendingInfo(id: id, username: username, profilePic: profilePic, intro: intro, tedoori: tedoori) //여기!!
        
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userHeaderTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func userHeaderTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        DispatchQueue.main.async { [weak self] in
            let userInfo = TodoUserInfo(
                id: sendingInfo.id, //여기!!
                tedoori: sendingInfo!.tedoori,
                profilePic: sendingInfo?.profilePic,
                username: sendingInfo!.username,
                intro: sendingInfo?.intro)
            let followingUserVC = UserTodoViewController(viewModel: UserTodoViewModel(userInfo: userInfo), followViewModel: FollowViewModel(followUseCase: FollowUseCase(followRepository: FollowRepository())), naviagateMethod: true)
            self?.navigationController?.pushViewController(followingUserVC, animated: true)
        }
    }
}

