//
//  FollowingView.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class FollowingView: UIView {
    private var viewModel = FollowViewModel(followUseCase: FollowUseCase(followRepository: FollowRepository()))
    private var followings: [Follow] = []
    
    private func fetchFollowings() {
        viewModel.getFollowInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let followInfo):
                    self?.followings = followInfo.followings
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 56, height: 80)
        return layout
    }()
    
    private lazy var myView = {
        let view = UserSmallView()
        view.configure(image: User.shared.profilePic, name: User.shared.username ?? "me")

        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.dataSource = self
        view.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.id)
        return view
    }()
    
    var onTap: (() -> Void)?
    
    @objc private func handleTap() {
        onTap?()
    }
    
    private lazy var button = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        
        let image = SymbolCircleView(symbolImage: UIImage(systemName: "chevron.right"), small: true)
        image.setBackgroundColor(.systemGray6)
        image.setSymbolColor(.secondaryLabel)
        
        button.addSubview(image)
        image.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        return button
    }()
    
    func refreshData() {
        fetchFollowings()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        fetchFollowings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(myView)
        myView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(myView.snp.trailing).offset(4)
            make.trailing.equalTo(button.snp.leading).offset(-4)
        }
    }
    
    
    
    
}

extension FollowingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.id, for: indexPath) as! UserCollectionViewCell
        let following = followings[indexPath.row]
        cell.configure(image: following.profile.profilePic, name: following.profile.username)
        return cell
    }
}
