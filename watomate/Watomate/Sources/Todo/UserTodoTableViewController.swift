//
//  UserTodoTableViewController.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class UserTodoTableViewController: UIViewController {
    
    private let viewModel: UserTodoViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: UserTodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var userView = {
        let view = UserTodoHeaderView()
        view.configure(with: viewModel)
        return view
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.text = Utils.getTodayString()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.semiBold, size: 16)
        return label
    }()
    
    private lazy var emptyLabel = {
        let label = UILabel()
        label.text = "작성된 할 일이 없어요"
        label.textColor = .secondaryLabel
        label.font = UIFont(name: Constants.Font.medium, size: 16)
        return label
    }()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .init(), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(TodoHeaderView.self, forHeaderFooterViewReuseIdentifier: TodoHeaderView.reuseIdentifier)
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        
        tableView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
        viewModel.input.send(.viewDidLoad)
    }
    
    internal func setupLayout() {
        view.addSubview(userView)
        userView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.trailing.bottom.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let viewModel = self?.viewModel else { return }
                switch event {
                case .updateUserTodo:
                    if viewModel.userTodos.isEmpty {
                        self?.emptyLabel.isHidden = false
                    } else {
                        self?.emptyLabel.isHidden = true
                        self?.tableView.reloadData()
                    }
                }
            }.store(in: &cancellables)
    }

}

extension UserTodoTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoHeaderView.reuseIdentifier) as? TodoHeaderView else { return nil }
        let goal = viewModel.userTodos[section]
        header.setTitle(with: goal.title)
        header.setColor(with: Color(rawValue: goal.color) ?? .blue)
        header.setVisibility(with: Visibility(rawValue: goal.visibility) ?? .PR)
        header.contentView.backgroundColor = .systemBackground
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
}

extension UserTodoTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.userTodos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userTodos[section].todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else { fatalError() }
        let goal = viewModel.userTodos[indexPath.section]
        let todo = goal.todos[indexPath.row]
        cell.configure(with: TodoCellViewModel(todo: Todo(uuid: UUID(), title: todo.title, color: goal.color, isCompleted: todo.isCompleted, goal: 0, likes: todo.likes.map{ Like(userId: $0.user, emoji: $0.emoji) })))
        cell.makeDotsHidden()
        cell.disableCheckbox()
        cell.selectionStyle = .none
        return cell
    }
    
    
}


