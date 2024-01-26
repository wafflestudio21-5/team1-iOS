//
//  BackgroundCollectionViewCell.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/25.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.isUserInteractionEnabled = true
        
        colorLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 1)
        label.textColor = .clear
        label.layer.cornerRadius = bounds.width / 2
        label.layer.masksToBounds = true
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemGray5.cgColor
        return label
    }()
    
    func configure(with color: String) {
        colorLabel.backgroundColor = UIColor(named: color)
        colorLabel.text = color
    }
    
    var onSelectionChanged: ((String) -> Void)?

    var selectedColor: String = "nil" {
        didSet {
            onSelectionChanged?(selectedColor)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedColor = colorLabel.text ?? "no color"
                colorLabel.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                colorLabel.layer.borderColor = UIColor.systemGray5.cgColor
            }
        }
    }
    
    
}

