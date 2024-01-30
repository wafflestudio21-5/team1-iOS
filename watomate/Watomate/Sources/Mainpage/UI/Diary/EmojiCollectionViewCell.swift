//
//  EmojiCollectionViewCell.swift
//  WaToDoMate
//
//  Created by 이수민 on 2024/01/09.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //backgroundColor = .white
        layer.cornerRadius = 8
    }
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    var onSelectionChanged: ((String) -> Void)?

    var selectedEmoji: String = "nil" {
        didSet {
            onSelectionChanged?(selectedEmoji)
        }
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            selectedEmoji = emojiLabel.text ?? "no emoji" 
            emojiLabel.backgroundColor = .blue
        } else {
            emojiLabel.backgroundColor = .white
        }
      }
    }
}

