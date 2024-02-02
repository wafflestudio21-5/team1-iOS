//
//  FollowingViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/02.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import Kingfisher

class FollowingViewController: PlainCustomBarViewController, UITabBarControllerDelegate {
    var viewModel = FollowViewModel(followUseCase: FollowUseCase(followRepository: FollowRepository()))
    private var isFollowingList: Bool = true // Default to "팔로잉"
    private var followMapping: [Int: Follow] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("팔로우")
        setLeftBackButton()
        setupTabBar()
        
    }

    private func setupTabBar() {
        let tabBar = UITabBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 36))
        tabBar.delegate = self
        
        UITabBar.appearance().tintColor = .black
        tabBar.backgroundColor = .systemBackground
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)

        let followingTabItem = UITabBarItem(title: "팔로잉", image: nil, selectedImage: nil)
        let followerTabItem = UITabBarItem(title: "팔로워", image: nil, selectedImage: nil)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        tabBar.setItems([followingTabItem, followerTabItem], animated: false)
        contentView.addSubview(tabBar)

        switchTabTo(tabItem: followingTabItem)
        
        contentView.addSubview(allFollowStackView)
        allFollowStackView.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    private func switchTabTo(tabItem: UITabBarItem) {
        if tabItem.title == "팔로잉" {
            isFollowingList = true
        } else if tabItem.title == "팔로워" {
            isFollowingList = false
        }
        print(isFollowingList)
        removeAllArrangedSubviewsFromStackView()
        getFollowInfo()
    }
    
    private func removeAllArrangedSubviewsFromStackView() {
        let arrangedSubviews = allFollowStackView.arrangedSubviews
        for view in arrangedSubviews {
            allFollowStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    private func getFollowInfo() {
        viewModel.getFollowInfo() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (followers, followings)):
                    if self?.isFollowingList == true {
                        self?.updateUI(followings)
                    } else {
                        self?.updateUI(followers)
                    }
                case .failure(let error):
                    print("Error fetching follow data: \(error.localizedDescription)")
                }
            }
        }
    }

    
    private func updateUI(_ follows: [Follow]) {
        for follow in follows {
            let followView = createFollowView(withFollow: follow)
            allFollowStackView.addArrangedSubview(followView)
            followView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(50)
            }
        }
    }
    
    private lazy var allFollowStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
   
    @objc func followViewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let followUserInfo = followMapping[view.tag]
        DispatchQueue.main.async { [weak self] in
            let userInfo = TodoUserInfo(id: (followUserInfo?.id)!,
                                        tedoori: (followUserInfo?.profile.tedoori)!,
                                        profilePic: followUserInfo?.profile.profilePic,
                                        username: (followUserInfo?.profile.username)!,
                                        intro: followUserInfo?.profile.intro)
            let followingUserVC = UserTodoViewController(viewModel: UserTodoViewModel(userInfo: userInfo))
            self?.navigationController?.pushViewController(followingUserVC, animated: true)
        }
    }
   
    private func createFollowView(withFollow followInfo: Follow) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.tag = followInfo.id
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followViewTapped))
        stackView.addGestureRecognizer(tapGesture)
        followMapping[followInfo.id] = followInfo
        //print(followMapping[followInfo.id])
        
        let followProfileImageContainer = createFollowProfileImageContainer()
        stackView.addArrangedSubview(followProfileImageContainer)
        if followInfo.profile.profilePic != nil{
            followProfileImageContainer.setFollowProfileImage(imageUrl: followInfo.profile.profilePic!)
        }
        followProfileImageContainer.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        let followProfileName = createFollowProfileName(withText: followInfo.profile.username)
        stackView.addArrangedSubview(followProfileName)
        followProfileName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview()
        }
        
        let followShowMoreButton = createFollowShowMoreButton(userId: followInfo.id)
        containerView.addSubview(followShowMoreButton)
        followShowMoreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }

        return containerView
    }

    private func createFollowProfileName(withText text : String) -> UILabel{
        let label = UILabel()
        label.text = text
        return label
    }
    
    private func createFollowProfileImageContainer()-> SymbolCircleView{
        let imageView = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        imageView.setBackgroundColor(.secondarySystemFill)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }
    
    private func createFollowShowMoreButton(userId : Int) -> UIButton{
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tag = userId
        button.addTarget(self, action: #selector(showMoreButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func showMoreButtonTapped(_ sender: UIButton) {
        let userId = sender.tag
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.unfollowUser(userId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.removeAllArrangedSubviewsFromStackView()
                        self.getFollowInfo()
                    case .failure(let error):
                        print("Error deleting goal: \(error)")
                    }
                }
            }
        }
        
        actionSheet.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(actionSheet, animated: true)
        }
    }

}


extension FollowingViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switchTabTo(tabItem: item)
    }
    
    
}
