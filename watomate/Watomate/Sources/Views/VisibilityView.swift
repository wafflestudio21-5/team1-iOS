//
//  VisibilityView.swift
//  Watomate
//
//  Created by 이지현 on 1/29/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class VisibilityView: UIStackView {
    private let visibility: Visibility
    
    init(_ visibility: Visibility) {
        self.visibility = visibility
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 1.adjusted
        
        addArrangedSubview(boxView)
        addArrangedSubview(visibilityLabel)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var boxView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var visibilityLabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Font.regular, size: 12)
        label.textColor = .label
        return label
    }()
    
    func setFontSize(_ size: CGFloat) {
        visibilityLabel.font = UIFont(name: Constants.Font.semiBold, size: size)
    }
    
    private func configure() {
        switch visibility {
        case .PB:
            boxView.image = UIImage(named: "pb")
            visibilityLabel.text = "전체공개"
        case .PR:
            boxView.image = UIImage(named: "pr")
            visibilityLabel.text = "나만보기"
        case .FL:
            boxView.image = UIImage(named: "fl")
            visibilityLabel.text = "팔로워 공개"
        }
    }
    
    func setLabelColor(_ color: UIColor) {
        visibilityLabel.textColor = color
    }
    
}
