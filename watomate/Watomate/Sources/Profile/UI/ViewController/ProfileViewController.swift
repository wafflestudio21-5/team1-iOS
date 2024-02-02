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
    
    override init(todoListViewModel: TodoListViewModel) {
        super.init(todoListViewModel: todoListViewModel)
        self.todoListViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        todoTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setLeftButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupTopBarItems()
    }
    
    private func setLeftButton() {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape", withConfiguration: configuration), style: .plain, target: self, action: #selector(settingButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: usernameLabel)
    }
    
    private func setupTopBarItems() {
        guard let username: String = User.shared.username else { return }
        if let headerView = todoTableView.headerView(forSection: 0) as? ProfileHeaderView {
            headerView.setProfileImage(with: nil)
        }
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
            header.archiveBoxTapEvent(target: self, action: #selector(archiveBoxTapped))
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
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func archiveBoxTapped(_ sender: UITapGestureRecognizer) {
        let viewController = ArchiveBoxViewController(viewModel: ArchiveBoxViewModel())
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 131.6667
        }
        return 60
    }
    
    @objc internal override func addEmptyTodo(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? GoalStackView else { return }
        let section = headerView.tag
        let success = todoListViewModel.appendPlaceholderIfNeeded(at: section, with: nil)
        if !success {
            todoTableView.endEditing(false)
        }
    }
}

extension ProfileViewController: TodoListViewModelDelegate {
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didInsertCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        Task { @MainActor in
            if let cell = todoTableView.cellForRow(at: indexPath) as? TodoCell {
                todoTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                cell.titleBecomeFirstResponder()
            }
        }
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, showDetailViewWith cellViewModel: TodoCellViewModel) {
        let vc = TodoDetailViewController(viewModel: cellViewModel)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didChangeDateOf cellViewModel: TodoCellViewModel) {
        if cellViewModel.date != nil {
            input.send(.viewDidAppear(self))
        }
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didUpdateViewModel cellViewModel: TodoCellViewModel) {
        return
    }
}
