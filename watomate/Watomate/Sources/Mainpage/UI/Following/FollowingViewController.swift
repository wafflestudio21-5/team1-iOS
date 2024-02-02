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
            let followView = createFollowView(withText: follow.profile.username, withImage: follow.profile.profilePic, withID: follow.id)
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
        let followID = view.tag

        DispatchQueue.main.async { [weak self] in
            let followingUserVC = testfollowingViewController(userID: followID)
            self?.navigationController?.pushViewController(followingUserVC, animated: true)
        }
    }

    private func createFollowView(withText text: String, withImage image: String, withID id: Int) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.tag = id
        
        let followProfileImageContainer = createFollowProfileImageContainer()
        stackView.addArrangedSubview(followProfileImageContainer)
        followProfileImageContainer.setFollowProfileImage(imageUrl: image)
        followProfileImageContainer.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        let followProfileName = createFollowProfileName(withText: text)
        stackView.addArrangedSubview(followProfileName)
        followProfileName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview()
        }
        
        let followShowMoreButton = createFollowShowMoreButton()
        containerView.addSubview(followShowMoreButton)
        followShowMoreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followViewTapped))
            stackView.addGestureRecognizer(tapGesture)

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
    
    private func createFollowShowMoreButton() -> UIButton{
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }

}


extension FollowingViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switchTabTo(tabItem: item)
    }
    
    
}
