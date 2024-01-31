//
//  LikeEmojiCell.swift
//  Watomate
//
//  Created by 이지현 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class LikeEmojiCell: UICollectionViewCell {
    static let identifier = "likeEmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emojiLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35)
        return label
    }()
    
    private func setupLayout() {
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func setEmoji(_ emoji: String) {
        emojiLabel.text = emoji
    }
}
