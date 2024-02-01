//
//  ArchiveBoxViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

class ArchiveBoxViewController: PlainCustomBarViewController {
    private let viewModel: ArchiveBoxViewModel
    private var imageListDataSource: UICollectionViewDiffableDataSource<ImageSection, ImageCellViewModel.ID>!

    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.delegate = self
        view.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        return view
    }()
    
    init(viewModel: ArchiveBoxViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        configureDataSource()
        bindViewModel()
        viewModel.input.send(.viewDidLoad)

    }
    
    private func setupNavigationBar() {
        setTitle("나의 인증샷")
        setLeftBackButton()
    }
    
    private func setupLayout() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        imageListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, itemIdentifier) -> ImageCell? in
            guard let self else { fatalError() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { fatalError() }
            cell.configure(with: self.viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func bindViewModel() {
        viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .updateImageList(imageList):
                    var snapshot = NSDiffableDataSourceSnapshot<ImageSection, ImageCellViewModel.ID>()
                    snapshot.appendSections(ImageSection.allCases)
                    snapshot.appendItems(imageList.map{ $0.id }, toSection: .main)
                    self?.imageListDataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)
    }

}

extension ArchiveBoxViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 3
        let widthPadding = 1 * (itemsPerRow + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ArchiveDetailViewController(viewModel: viewModel.viewModel(at: indexPath)), animated: true)
    }
    
}

extension ArchiveBoxViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let viewContentSize = collectionView.contentSize.height
        
        if contentOffsetY > (viewContentSize - collectionView.bounds.size.height - 200) {
            viewModel.input.send(.reachedEndOfScrollView)
        }
    }
}
