//
//  GoalStackView.swift
//  Watomate
//
//  Created by 권현구 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class GoalStackView: UIStackView {
    private lazy var privacyImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = "sample goal"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addImage = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    init() {
        super.init(frame: .init())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = 10
        self.alignment = .center
        self.backgroundColor = .secondarySystemBackground
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addArrangedSubview(privacyImageView)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(addImage)
        
        self.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.isLayoutMarginsRelativeArrangement = true
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func withTitle(title: String) -> GoalStackView {
        self.titleLabel.text = title
        return self
    }
}
