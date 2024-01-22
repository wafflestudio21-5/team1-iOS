//
//  InitialUserViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

class InitialUserViewController: UIViewController {
    private let viewModel: InitialUserViewModel
    private var userListDataSource: UITableViewDiffableDataSource<InitialUserSection, UserCellViewModel.ID>!

    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: InitialUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
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
        userListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell else { fatalError() }
            cell.configure(with: self.viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updateUserList(let userList):
                    var snapshot = NSDiffableDataSourceSnapshot<InitialUserSection, UserCellViewModel.ID>()
                    snapshot.appendSections(InitialUserSection.allCases)
                    snapshot.appendItems(userList.map{ $0.id }, toSection: .main)
                    self?.userListDataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)
    }

}

extension InitialUserViewController: UITableViewDelegate {
    
}

extension InitialUserViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 100) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}
