//
//  InitialTodoViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

class InitialTodoViewController: UIViewController {
    private let viewModel: InitialTodoViewModel
    private var todoListDataSource: UITableViewDiffableDataSource<InitialTodoSection, TodoUserCellViewModel.ID>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: InitialTodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.register(TodoUserCell.self, forCellReuseIdentifier: TodoUserCell.reuseIdentifier)
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
        configureDataSource()
        bindViewModel()
        viewModel.input.send(.viewDidLoad)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        todoListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoUserCell.reuseIdentifier, for: indexPath) as? TodoUserCell else { fatalError() }
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
                    var snapshot = NSDiffableDataSourceSnapshot<InitialTodoSection, TodoUserCellViewModel.ID>()
                    snapshot.appendSections(InitialTodoSection.allCases)
                    snapshot.appendItems(todoList.map{ $0.id }, toSection: .main)
                    self?.todoListDataSource.apply(snapshot, animatingDifferences: false)
                }
            }.store(in: &cancellables)
    }


}

extension InitialTodoViewController: UITableViewDelegate {
    
}

extension InitialTodoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 100) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}

