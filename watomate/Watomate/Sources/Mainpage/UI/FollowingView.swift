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
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
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
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.id, for: indexPath) as! UserCollectionViewCell
        cell.configure(image: nil, name: "me")
        return cell
    }
    
    
}
