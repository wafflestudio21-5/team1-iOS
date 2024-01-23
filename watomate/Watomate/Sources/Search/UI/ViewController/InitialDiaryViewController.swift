//
//  InitialDiaryViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import UIKit
import SnapKit

class InitialDiaryViewController: UIViewController {
    private let viewModel: InitialDiaryViewModel
    private var diaryListDataSource: UITableViewDiffableDataSource<InitialDiarySection, DiaryCellViewModel.ID>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: InitialDiaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        tableView.delegate = self
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15.adjusted)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        diaryListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.reuseIdentifier, for: indexPath) as? DiaryCell else { fatalError() }
            cell.configure(with: self.viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updateDiaryList(let diaryList):
                    var snapshot = NSDiffableDataSourceSnapshot<InitialDiarySection, DiaryCellViewModel.ID>()
                    snapshot.appendSections(InitialDiarySection.allCases)
                    snapshot.appendItems(diaryList.map{ $0.id }, toSection: .main)
                    self?.diaryListDataSource.apply(snapshot, animatingDifferences: false)
                }
            }.store(in: &cancellables)
    }

}

extension InitialDiaryViewController: UITableViewDelegate {
    
}

extension InitialDiaryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 100) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}
