//
//  SymbolCircleView.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class SymbolCircleView: UIView {
    private var symbolImage: UIImage?
    private var borderColor: UIColor? = nil
    
    private lazy var symbolImageView = {
        let imageView = UIImageView()
        imageView.image = symbolImage
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(symbolImage: UIImage?) {
        super.init(frame: .zero)
        self.symbolImage = symbolImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeCircle()
        setupLayout()
    }
    
    private func makeCircle() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    private func setupLayout() {
        addSubview(symbolImageView)
        symbolImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(frame.width / 5)
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    func setSymbolColor(_ color: UIColor) {
        symbolImageView.tintColor = color 
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        borderColor = color
    }
    
}