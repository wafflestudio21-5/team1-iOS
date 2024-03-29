//
//  TodoTableViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class TodoTableViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Int, TodoCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TodoCellViewModel>
    
    var dataSource: DataSource!
    var snapshot: Snapshot!
    
    internal let todoListViewModel : TodoListViewModel
    
    internal let input = PassthroughSubject<TodoListViewModel.Input, Never>()
    internal var cancellables = Set<AnyCancellable>()
    internal var viewModelCancellables: AnyCancellable?
    
    init(todoListViewModel: TodoListViewModel) {
        self.todoListViewModel = todoListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal lazy var todoTableView = {
        let tableView = UITableView(frame: .init(), style: .grouped)
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear(self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.register(TodoHeaderView.self, forHeaderFooterViewReuseIdentifier: TodoHeaderView.reuseIdentifier)
        todoTableView.register(CalendarHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarHeaderView.reuseIdentifier)
        registerCells()
        setupLayout()
        configureDataSource()
        bindViewModel()
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
        for i in 0..<viewModels.count {
            guard let cellVMs = viewModels[i + 1] else { return }
            snapshot.appendItems(cellVMs, toSection: i + 1)
        }
        todoTableView.reloadData()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension TodoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UITableViewHeaderFooterView()
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

extension TodoTableViewController: TodoDetailViewDelegate {
    func deleteTodoCell(with viewModel: TodoCellViewModel) {
        guard let indexPath = todoListViewModel.indexPath(with: viewModel.uuid) else { return }
        self.todoListViewModel.remove(at: indexPath)
    }
    
    func didEndEditingMemo(viewModel: TodoCellViewModel) {
        let todo = Todo(uuid: viewModel.uuid, 
                        id: viewModel.id,
                        title: viewModel.title, 
                        color: viewModel.color,
                        description: viewModel.memo,
                        reminder: viewModel.reminder,
                        date: viewModel.date,
                        isCompleted: viewModel.isCompleted, 
                        goal: viewModel.goal,
                        likes: viewModel.likes)
        todoListViewModel.todoCellViewModel(viewModel, didUpdateItem: todo)
    }
    
    func editTitle(with viewModel: TodoCellViewModel) {
        guard let indexPath = todoListViewModel.indexPath(with: viewModel.uuid) else { return }
        let cell = todoTableView.cellForRow(at: indexPath) as! TodoCell
        cell.canEditTitle()
    }
}
