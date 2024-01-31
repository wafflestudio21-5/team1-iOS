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
    private lazy var visibilityImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
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
        
        visibilityImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        self.addArrangedSubview(visibilityImageView)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(addImage)
        
        self.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
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
    
    func setTitle(with title: String) {
        self.titleLabel.text = title
    }
    
    func setTitleFont(font: UIFont) {
        self.titleLabel.font = font
    }
    
    func setColor(color: Color) {
        self.titleLabel.textColor = color.uiColor
    }
    
    func setVisibility(visibility: Visibility) {
        let stringVal = switch visibility {
        case .FL:
            "fl"
        case .PB:
            "pb"
        case .PR:
            "pr"
        }
        visibilityImageView.image = UIImage(named: stringVal)
    }
}
