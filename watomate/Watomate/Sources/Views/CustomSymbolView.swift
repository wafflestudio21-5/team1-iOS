//
//  CustomSymbolView.swift
//  Watomate
//
//  Created by 이지현 on 1/24/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

import UIKit

class CustomSymbolView: UIView {
    
    private lazy var containerView = UIView()
    
    private lazy var circle1 = SymbolCircleView(symbolImage: nil)
    private lazy var circle2 = SymbolCircleView(symbolImage: nil)
    private lazy var circle3 = SymbolCircleView(symbolImage: nil)
    private lazy var circle4 = SymbolCircleView(symbolImage: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let circleDiameter = bounds.height / 2.4
        setupCircles(circleDiameter: circleDiameter)
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCircles(circleDiameter: CGFloat) {
        circle1.setBackgroundColor(Color.gray.uiColor)
        containerView.addSubview(circle1)
        circle1.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.trailing.equalToSuperview().inset(circleDiameter)
        }
        
        circle2.setBackgroundColor(Color.gray.uiColor)
        containerView.addSubview(circle2)
        circle2.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.bottom.leading.equalToSuperview().inset(circleDiameter)
        }
        
        circle3.setBackgroundColor(Color.gray.uiColor)
        containerView.addSubview(circle3)
        circle3.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.top.leading.equalToSuperview().inset(circleDiameter)
        }
        
        circle4.setBackgroundColor(Color.gray.uiColor)
        containerView.addSubview(circle4)
        circle4.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.top.trailing.equalToSuperview().inset(circleDiameter)
        }
    }
}

