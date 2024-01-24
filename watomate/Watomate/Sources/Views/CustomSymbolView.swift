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
    
    private var size:CGFloat = 0
    
    private lazy var containerView = UIView()
    
    private lazy var circle1 = SymbolCircleView(symbolImage: nil)
    private lazy var circle2 = SymbolCircleView(symbolImage: nil)
    private lazy var circle3 = SymbolCircleView(symbolImage: nil)
    private lazy var circle4 = SymbolCircleView(symbolImage: nil)
    
    private lazy var centerCircle = {
        let view = SymbolCircleView(symbolImage: nil)
        view.setSymbolColor(.white)
        return view
    }()

    private var didSetupConstraints = false
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        self.size = size
        backgroundColor = .clear
        
        setupLayout()
        
        let inset = size / 2.7
        setupCircles(circleInset: inset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCircles(circleInset: CGFloat) {
        setupCirclesColor()
        containerView.addSubview(circle1)
        circle1.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.trailing.equalToSuperview().inset(circleInset)
        }

        containerView.addSubview(circle2)
        circle2.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.bottom.leading.equalToSuperview().inset(circleInset)
        }
        
        containerView.addSubview(circle3)
        circle3.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.top.leading.equalToSuperview().inset(circleInset)
        }
        
        containerView.addSubview(circle4)
        circle4.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.top.trailing.equalToSuperview().inset(circleInset)
        }
    }
    
    private func setupCirclesColor() {
        for circle in [circle1, circle2, circle3, circle4] {
            circle.setBackgroundColor(Color.gray.uiColor)
            circle.alpha = 1
        }
    }
    
    func setColor(color: [Color]) {
        if color.count >= 4 {
            circle1.backgroundColor = color[0].uiColor
            circle2.backgroundColor = color[1].uiColor
            circle3.backgroundColor = color[2].uiColor
            circle4.backgroundColor = color[3].uiColor
        } else if color.count == 3 {
            circle1.backgroundColor = color[0].uiColor
            circle2.backgroundColor = color[1].uiColor
            circle3.backgroundColor = color[2].uiColor
            circle4.backgroundColor = color[0].uiColor
        } else if color.count == 2 {
            circle1.backgroundColor = color[0].uiColor
            circle2.backgroundColor = color[1].uiColor
            circle3.backgroundColor = color[0].uiColor
            circle4.backgroundColor = color[1].uiColor
        } else if color.count == 1{
            circle1.backgroundColor = color[0].uiColor
            circle2.backgroundColor = color[0].uiColor
            circle3.backgroundColor = color[0].uiColor
            circle4.backgroundColor = color[0].uiColor
        } else { return }
    }
    
    func addCenterCircle(image: UIImage?) {
        containerView.addSubview(centerCircle)
        centerCircle.snp.makeConstraints { make in
            make.width.height.equalTo(size/1.3)
            make.center.equalToSuperview()
        }
        
        centerCircle.setSymbol(image)
    }
    
    func addDefaultImage() {
        addCenterCircle(image: UIImage(systemName: "person.fill"))
        centerCircle.setBackgroundColor(Color.gray.uiColor)
    }
    
    func addNumber(numberString: String) {
        let image = numberString.image(withAttributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: size, weight: .bold)
        ])
        containerView.addSubview(centerCircle)
        centerCircle.snp.makeConstraints { make in
            make.width.height.equalTo(size/1)
            make.center.equalToSuperview()
        }
        
        centerCircle.setSymbol(image)
    }
    
    func addSymbol(systemName: String) {
        addCenterCircle(image: UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(weight: .bold)))
    }
    
    func addCheckMark() {
        addCenterCircle(image: UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)))
    }

}

