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
    
    typealias DataSource = UITableViewDiffableDataSource<Int, Todo>
    
    private lazy var profileViewControllerViewModel = {
        let viewModel = ProfileViewControllerViewModel(repository: TodoItemRepository())
        viewModel.delegate = self
        return viewModel
    }()
    
    private lazy var todoTableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
//        tableView.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 0)
//        tableView.separatorColor = .tertiaryLabel
//        tableView.tableHeaderView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap(_:)))
        tableView.addGestureRecognizer(tapGesture)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBarItems()
        todoTableView.register(TodoHeaderView.self, forHeaderFooterViewReuseIdentifier: TodoHeaderView.reuseIdentifier)
        todoTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        registerCells()
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        Task { @MainActor in
            await profileViewControllerViewModel.getAllTodos()
            todoTableView.reloadData()
        }
    }
    
    private var usernameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private func setupTopBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: usernameLabel)
    }
    
    private func setupLayout() {
        view.addSubview(todoTableView)
        todoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func registerCells() {
        todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
    }
    
    @objc private func handleTableViewTap(_ gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: todoTableView)
//        if location.y > todoTableView.contentSize.height {
//            let success = profileViewControllerViewModel.appendPlaceholderIfNeeded()
//            if !success {
//                todoTableView.endEditing(false)
//            }
//        }
    }
    
    @objc private func settingButtonTapped() {
        let settingsViewController = SettingsViewController()
        print([Int: TodoCellViewModel]().count)
        Task { @MainActor in
            await profileViewControllerViewModel.getAllTodos()
        }
        
//        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            profileViewControllerViewModel.remove(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.reuseIdentifier) as? ProfileHeaderView else { return nil }
            return header
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoHeaderView.reuseIdentifier) as? TodoHeaderView else { return nil }
        header.setTitle(with: profileViewControllerViewModel.getTitle(of: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 131.6667
        }
        return 60
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewControllerViewModel.numberOfRowsInSection(section: section - 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todoTableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else { fatalError() }
        cell.selectionStyle = .none
        guard let viewModel = profileViewControllerViewModel.viewModel(at: indexPath) else { 
            cell.backgroundColor = .yellow
            return cell }
        viewModel.delegate = profileViewControllerViewModel
        cell.configure(with: viewModel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileViewControllerViewModel.sectionsForGoalId.count + 1
    }
}

extension ProfileViewController: ProfileViewControllerViewModelDelegate {
    func profileViewControllerViewModel(_ viewModel: ProfileViewControllerViewModel, didInsertTodoViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        Task { @MainActor in
            todoTableView.insertRows(at: [indexPath], with: .none)
            todoTableView.reloadRows(at: [indexPath], with: .none)
            if let cell = todoTableView.cellForRow(at: indexPath) as? TodoCell {
                cell.titleBecomeFirstResponder()
                todoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
    //        updateUnavailableView()
        }
    }

    func profileViewControllerViewModel(_ viewModel: ProfileViewControllerViewModel, didRemoveTodoViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath, options: ReloadOptions) {
        if options.contains(.reload) {
            let animated = options.contains(.animated)
            todoTableView.deleteRows(at: [indexPath], with: animated ? .automatic : .none)
        }
//        updateUnavailableView()
    }
    
    func profileViewControllerViewModel(_ viewModel: ProfileViewControllerViewModel, didInsertTodoViewModels newViewModels: [TodoCellViewModel], at indexPaths: [IndexPath]) {
        Task { @MainActor in
            self.todoTableView.insertRows(at: indexPaths, with: .fade)
            todoTableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
}
