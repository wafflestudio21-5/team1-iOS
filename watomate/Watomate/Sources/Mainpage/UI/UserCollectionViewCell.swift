//
//  UserCollectionViewCell.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    static let id = "userCollectionViewCell"
    
    private lazy var profileView = SymbolCircleView(symbolImage: nil)
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Font.regular, size: 5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(contentView.frame.width)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileView.reset()
        nameLabel.text = nil
    }
    
    func configure(image: String?, name: String) {
        if let image {
            profileView.setImage(image)
        } else {
            profileView.setDefault()
        }
        nameLabel.text = name
    }
    
}
