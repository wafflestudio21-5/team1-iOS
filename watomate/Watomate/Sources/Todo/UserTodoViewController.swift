//
//  UserTodoViewController.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class UserTodoViewController: PlainCustomBarViewController {
    var viewModel: UserTodoViewModel
    var followViewModel : FollowViewModel
    init(viewModel: UserTodoViewModel, followViewModel: FollowViewModel) {
        self.viewModel = viewModel
        self.followViewModel = followViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFollow(tappedId: viewModel.userId)
        setFollowButton(isFollowing: self.isFollowing)
        setFollowAction(target: self, action: #selector(followTapped))
        setLeftBackXNavigateButton()
        addChildViewController()
    }
    
    var isFollowing = true
    private func checkFollow(tappedId : Int){
        self.followViewModel.checkFollow(checkId: tappedId) { isFollowing in
            self.isFollowing = isFollowing
        }
    }
    
    @objc private func followTapped(_ sender: UIButton) {
        guard let myId = User.shared.id else { return } // 내 아이디
        let tappedId = viewModel.userId // 팔로우할 유저 아이디
        
        isFollowing.toggle()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: Constants.Font.semiBold, size: 15)
    
        followViewModel.checkFollow(checkId: tappedId) { isFollowing in
            if isFollowing {
                self.followViewModel.unfollowUser(tappedId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.setFollowButton(isFollowing: false)
                        case .failure(let error):
                            print("Error unfollowing user: \(error)")
                        }
                    }
                }
               
            } else {
                self.followViewModel.followUser(tappedId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.setFollowButton(isFollowing: true)
                        case .failure(let error):
                            print("Error following user: \(error)")
                        }
                    }
                }
                
            }
        }

    }
    
    
    
    private func addChildViewController() {
        let childViewController = UserTodoTableViewController(viewModel: viewModel)

        addChild(childViewController)
        contentView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        childViewController.didMove(toParent: self)
    }
    

}
