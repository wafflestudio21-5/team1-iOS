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

class ProfileViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Int, TodoCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TodoCellViewModel>
    
    var dataSource: DataSource!
    var snapshot: Snapshot!
    
    private let todoListViewModel : TodoListViewModel
    
    private let input = PassthroughSubject<TodoListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var viewModelCancellables: AnyCancellable?
    
    init(todoListViewModel: TodoListViewModel) {
        self.todoListViewModel = todoListViewModel
        super.init(nibName: nil, bundle: nil)
        self.todoListViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var usernameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var todoTableView = {
        let tableView = UITableView(frame: .init(), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEmptyTableViewTap(_:)))
        tableView.addGestureRecognizer(tapGesture)
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBarItems()
        todoTableView.register(TodoHeaderView.self, forHeaderFooterViewReuseIdentifier: TodoHeaderView.reuseIdentifier)
        todoTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        registerCells()
        setupLayout()
        configureDataSource()
        bindViewModel()
        registerKeyboardNotification()
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
    
    private func setupLayout() {
        view.addSubview(todoTableView)
        todoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func registerCells() {
        todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
    }
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            todoTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            todoTableView.scrollIndicatorInsets = todoTableView.contentInset
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        todoTableView.contentInset = UIEdgeInsets.zero
        todoTableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: todoTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as! TodoCell
            cell.configure(with: itemIdentifier)
            return cell
        })
    }
    
    private func bindViewModel() {
        let output = todoListViewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadFailed(let errorMsg):
                    print("error: \(errorMsg)")
                }
            }.store(in: &cancellables)

        viewModelCancellables = todoListViewModel.vms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModels in
                self?.applySnapshot(with: viewModels)
            }
    }
    
    private func applySnapshot(with viewModels: [Int: [TodoCellViewModel]]) {
        self.snapshot = Snapshot()
        let sections = Array(0...viewModels.count)
        snapshot.appendSections(sections)
        if viewModels.count == 0 {
            return
        }
        for i in 0...viewModels.count - 1 {
            guard let cellVMs = viewModels[i + 1] else { return }
            snapshot.appendItems(cellVMs, toSection: i + 1)
        }
        todoTableView.reloadData()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func handleEmptyTableViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: todoTableView)
        if location.y > todoTableView.contentSize.height {
            print("need to generate new cell")
//            let success = profileViewControllerViewModel.appendPlaceholderIfNeeded()
//            if !success {
//                todoTableView.endEditing(false)
//            }
        }
    }
    
    @objc private func settingButtonTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    @objc private func addEmptyTodo(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? GoalStackView else { return }
            
        let section = headerView.tag
        let success = todoListViewModel.appendPlaceholderIfNeeded(at: section)
        if !success {
            todoTableView.endEditing(false)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 131.6667
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
}

extension ProfileViewController: TodoListViewModelDelegate {
    func todoListViewModel(_ viewModel: TodoListViewModel, didUpdateItem: Todo, at indexPath: IndexPath) {

    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didInsertCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        Task { @MainActor in
            if let cell = todoTableView.cellForRow(at: indexPath) as? TodoCell {
                cell.titleBecomeFirstResponder()
                todoTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
    //        updateUnavailableView()
        }
    }

    func todoListViewModel(_ viewModel: TodoListViewModel, didRemoveCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath, options: ReloadOptions) {
        if options.contains(.reload) {
            let animated = options.contains(.animated)
            todoTableView.deleteRows(at: [indexPath], with: animated ? .automatic : .none)
        }
//        updateUnavailableView()
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, showDetailViewWith cellViewModel: TodoCellViewModel) {
        let vc = TodoDetailViewController(viewModel: cellViewModel)
        vc.delegate = self
        present(vc, animated: true)
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

extension ProfileViewController: TodoDetailViewDelegate {
    func deleteTodoCell(with viewModel: TodoCellViewModel) {
        guard let indexPath = todoListViewModel.indexPath(with: viewModel.uuid) else { return }
        self.todoListViewModel.remove(at: indexPath)
    }
    
    func didEndEditingMemo(viewModel: TodoCellViewModel) {
        let todo = Todo(uuid: viewModel.uuid, id: viewModel.id, title: viewModel.title, color: viewModel.color, description: viewModel.memo, isCompleted: viewModel.isCompleted, goal: viewModel.goal, likes: viewModel.likes)
        todoListViewModel.todoCellViewModel(viewModel, didUpdateItem: todo)
    }
    
    func editTitle(with viewModel: TodoCellViewModel) {
        guard let indexPath = todoListViewModel.indexPath(with: viewModel.uuid) else { return }
        let cell = todoTableView.cellForRow(at: indexPath) as! TodoCell
        cell.canEditTitle()
    }
}
