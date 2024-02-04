//
//  UserFeedViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import UIKit

class UserFeedViewController: UIViewController {
    private let viewModel: UserFeedViewModel
    private var userListDataSource: UITableViewDiffableDataSource<UserFeedSection, UserCellViewModel.ID>!

    private var cancellables = Set<AnyCancellable>()
    
    init(searchText: String?, viewModel: UserFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.searchText = searchText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
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
            make.leading.trailing.bottom.equalToSuperview()

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
                    var snapshot = NSDiffableDataSourceSnapshot<UserFeedSection, UserCellViewModel.ID>()
                    snapshot.appendSections(UserFeedSection.allCases)
                    snapshot.appendItems(userList.map{ $0.id }, toSection: .main)
                    self?.userListDataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)
    }

}

extension UserFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserTodoViewController(viewModel: UserTodoViewModel(userInfo: TodoUserInfo(userCellViewModel: viewModel.viewModel(at: indexPath))), followViewModel: FollowViewModel(followUseCase: FollowUseCase(followRepository: FollowRepository())), naviagateMethod: false)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension UserFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 200) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}

