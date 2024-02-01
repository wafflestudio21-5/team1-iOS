//
//  ImageCell.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "imageCell"
    var viewModel: ImageCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        imageView.image = nil
    }
    
    private lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.85)
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.trailing.leading.equalToSuperview().inset(4)
        }
        
        return view
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.85)
        label.font = UIFont(name: Constants.Font.medium, size: 14)
        return label
    }()
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(6)
        }
    }
    
    func configure(with viewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        imageView.kf.setImage(with: URL(string: viewModel.image)!,
        options: [
            .processor(DownsamplingImageProcessor(size: .init(width: 200, height: 200)))
        ])
        dateLabel.text = Utils.convertToKorean(date: viewModel.date)
    
    }
}
