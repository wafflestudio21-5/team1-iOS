//
//  ProfileViewController.swift
//  Watomate
//
//  Created by 이수민 on 2023/12/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class ProfileViewController: TodoTableViewController {
    
    private var usernameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        todoTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupTopBarItems()
    }
    
    private func setupTopBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: usernameLabel)
        guard let username: String = User.shared.username else { return }
        usernameLabel.text = username
    }
    
    @objc private func settingButtonTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.reuseIdentifier) as? ProfileHeaderView else { return nil }
            header.contentView.backgroundColor = .systemBackground
            header.setProfileImage(with: nil)
            header.addProfileTapEvent(target: self, action: #selector(profileImageTapped))
            header.setFollowerCount()
            header.setFollowingCount()
            return header
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoHeaderView.reuseIdentifier) as? TodoHeaderView else { return nil }
        header.goalView.tag = section
        header.setTitle(with: todoListViewModel.getTitle(of: section))
        header.setColor(with: todoListViewModel.getColor(of: section))
        header.setVisibility(with: todoListViewModel.getVisibility(of: section))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addEmptyTodo))
        header.goalView.addGestureRecognizer(tapGesture)
        header.goalView.isUserInteractionEnabled = true
        header.contentView.backgroundColor = .systemBackground
        return header
    }
    
    @objc private func profileImageTapped(_ sender: UITapGestureRecognizer) {
        let viewController = ProfileEditViewController(viewModel: ProfileEditViewModel(userUseCase: UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())))
        viewController.delegate = self 
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 131.6667
        }
        return 60
    }
}

extension ProfileViewController: ProfileEditViewDelegate {
    func showProfileImage(_ image: UIImage?) {
        if let headerView = todoTableView.headerView(forSection: 0) as? ProfileHeaderView {
            headerView.setProfileImage(with: image)
//            headerView.setNeedsLayout()
//            headerView.layoutIfNeeded()
        }
    }
}
