//
//  TodoFeedViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

class TodoFeedViewController: UIViewController {
    private let viewModel: TodoFeedViewModel
    private var todoListDataSource: UITableViewDiffableDataSource<TodoSectionViewModel.ID, SearchTodoCellViewModel.ID>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(searchText: String?, viewModel: TodoFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.searchText = searchText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchTodoCell.self, forCellReuseIdentifier: SearchTodoCell.reuseIdentifier)
        tableView.register(UserHeaderView.self, forHeaderFooterViewReuseIdentifier: UserHeaderView.reuseIdentifier)
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false 
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        setupLayout()
        configureDataSource()
        bindViewModel()
        viewModel.input.send(.viewDidLoad)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15.adjusted)
            make.bottom.trailing.leading.equalToSuperview()

        }
    }
    
    private func configureDataSource() {
        todoListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTodoCell.reuseIdentifier, for: indexPath) as? SearchTodoCell else { fatalError() }
            cell.configure(with: self.viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updateTodoList(let todoList):
                    var snapshot = NSDiffableDataSourceSnapshot<TodoSectionViewModel.ID, SearchTodoCellViewModel.ID>()
                    snapshot.appendSections(todoList.map{ $0.id })
                    for user in todoList {
                        snapshot.appendItems(user.todoCells.map{ $0.id }, toSection: user.id)
                    }
                    self?.todoListDataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)
    }


}

extension TodoFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserHeaderView.reuseIdentifier) as? UserHeaderView else { fatalError() }
        header.configure(username: viewModel.sectionUsername(at: section), profilePic: viewModel.sectionProfilePic(at: section))
        return header
    }
    
}

extension TodoFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 400) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}

