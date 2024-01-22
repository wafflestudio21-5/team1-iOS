//
//  DiaryCell.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class DiaryCell: UITableViewCell {
    static let reuseIdentifier = "DiaryCell"
    private var viewModel: DiaryCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private func setupLayout() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(with viewModel: DiaryCellViewModel) {
        self.viewModel = viewModel
        descriptionLabel.text = viewModel.description
    }
}
