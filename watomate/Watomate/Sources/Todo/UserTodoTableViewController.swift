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
    
    typealias DataSource = UITableViewDiffableDataSource<Int, TodoCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TodoCellViewModel>
    
    var dataSource: DataSource!
    var snapshot: Snapshot!
    
    internal let viewModel : UserTodoViewModel
    
    internal let input = PassthroughSubject<TodoListViewModel.Input, Never>()
    internal var cancellables = Set<AnyCancellable>()
    internal var viewModelCancellables: AnyCancellable?
    
    init(viewModel: UserTodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal lazy var todoTableView = {
        let tableView = UITableView(frame: .init(), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(UserTodoHeaderView.self, forHeaderFooterViewReuseIdentifier: UserTodoHeaderView.reuseIdentifier)
        tableView.register(TodoHeaderView.self, forHeaderFooterViewReuseIdentifier: TodoHeaderView.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupLayout()
        configureDataSource()
//        bindViewModel()
        registerKeyboardNotification()
    }
    
    internal func setupLayout() {
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
    
//    private func bindViewModel() {
//        let output = viewModel.transform(input: input.eraseToAnyPublisher())
//        output.receive(on: DispatchQueue.main)
//            .sink { [weak self] event in
//                switch event {
//                case .loadFailed(let errorMsg):
//                    print("error: \(errorMsg)")
//                }
//            }.store(in: &cancellables)
//
//        viewModelCancellables = viewModel.vms
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] viewModels in
//                self?.applySnapshot(with: viewModels)
//            }
//    }
    
    private func applySnapshot(with viewModels: [Int: [TodoCellViewModel]]) {
        self.snapshot = Snapshot()
        let sections = Array(0...viewModels.count)
        snapshot.appendSections(sections)
        if viewModels.count == 0 {
            return
        }
        for i in 0..<viewModels.count {
            guard let cellVMs = viewModels[i + 1] else { return }
            snapshot.appendItems(cellVMs, toSection: i + 1)
        }
        todoTableView.reloadData()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UserTodoTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserTodoHeaderView.reuseIdentifier) as? UserTodoHeaderView else { return nil }
            header.contentView.backgroundColor = .systemBackground
            header.configure(with: viewModel)
            return header
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoHeaderView.reuseIdentifier) as? TodoHeaderView else { return nil }
//        header.goalView.tag = section
//        header.setTitle(with: viewModel.getTitle(of: section))
//        header.setColor(with: viewModel.getColor(of: section))
//        header.setVisibility(with: viewModel.getVisibility(of: section))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addEmptyTodo))
        header.goalView.addGestureRecognizer(tapGesture)
        header.goalView.isUserInteractionEnabled = true
        header.contentView.backgroundColor = .systemBackground
        return header
    }
    
    @objc internal func addEmptyTodo(_ sender: UITapGestureRecognizer) { }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
}


