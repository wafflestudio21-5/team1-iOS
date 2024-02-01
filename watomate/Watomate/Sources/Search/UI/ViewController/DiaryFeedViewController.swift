//
//  DiaryFeedViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import UIKit
import SnapKit

class DiaryFeedViewController: UIViewController {
    private let viewModel: DiaryFeedViewModel
    private var diaryListDataSource: UITableViewDiffableDataSource<DiaryFeedSection, SearchDiaryCellViewModel.ID>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DiaryFeedViewModel) {
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
        tableView.register(SearchDiaryCell.self, forCellReuseIdentifier: SearchDiaryCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false 
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDiaryCell.reuseIdentifier, for: indexPath) as? SearchDiaryCell else { fatalError() }
            cell.delegate = self
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
                    var snapshot = NSDiffableDataSourceSnapshot<DiaryFeedSection, SearchDiaryCellViewModel.ID>()
                    snapshot.appendSections(DiaryFeedSection.allCases)
                    snapshot.appendItems(diaryList.map{ $0.id }, toSection: .main)
                    self?.diaryListDataSource.apply(snapshot, animatingDifferences: true)
                case .likeUpdate:
                    guard let self else { return }
                    self.diaryListDataSource.applySnapshotUsingReloadData(self.diaryListDataSource.snapshot())
                }
            }.store(in: &cancellables)
    }

}

extension DiaryFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MateDiaryViewController(viewModel.viewModel(at: indexPath))
        vc.delegate = self
        present(vc, animated: true)
        
    }
}

extension DiaryFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        
        if contentOffsetY > (tableViewContentSize - tableView.bounds.size.height - 400) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}

extension DiaryFeedViewController: SearchDiaryCellDelegate {
    func selectEmoji(diaryId: Int, userId: Int) {
        let vc = LikeEmojiViewController()
        vc.diaryId = diaryId
        vc.userId = userId
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 280
            })]
        }
        present(vc, animated: true)
    }
}

extension DiaryFeedViewController: LikeEmojiViewControllerDelegate {
    func likeWithEmoji(diaryId: Int, user: Int, emoji: String) {
        viewModel.input.send(.likeTapped(diaryId: diaryId, userId: user, emoji: emoji))
    }
    
}

extension DiaryFeedViewController: MateDiaryViewControllerDelegate {
    func updateComments(diaryId: Int, comments: [CommentCellViewModel]) {
        viewModel.input.send(.updateComment(diaryId: diaryId, comments: comments))
    }
    
    func likedWithEmoji(diaryId: Int, user: Int, emoji: String) {
        viewModel.input.send(.likeAppended(diaryId: diaryId, userId: user, emoji: emoji))
    }
    
    
}
