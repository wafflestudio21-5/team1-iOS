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
        layout.itemSize = CGSize(width: 50, height: 60)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.id)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    
}
