//
//  SymbolCircleView.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Kingfisher
import UIKit

class SymbolCircleView: UIImageView {
    private var symbolImage: UIImage?
    private var borderColor: UIColor? = nil
    
    private var small: Bool
    
    // 심볼 기본 컬러: 화이트
    private lazy var symbolImageView = {
        let imageView = UIImageView()
        imageView.image = symbolImage
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    init(symbolImage: UIImage?, small: Bool = false) {
        self.small = small
        super.init(frame: .zero)
        self.symbolImage = symbolImage
        contentMode = .scaleAspectFill
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
            if small {
                make.edges.equalToSuperview().inset(frame.width / 3)
            } else {
                make.edges.equalToSuperview().inset(frame.width / 5.5)
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    func setSymbolColor(_ color: UIColor) {
        symbolImageView.tintColor = color 
    }
    
    func setSymbol(_ image: UIImage?) {
        symbolImageView.image = image
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        borderColor = color
    }
    
    func setImage(_ image: UIImage?) {
        self.image = image
        symbolImageView.image = nil
    }
    
    func setImage(_ url: String?) {
        if let url {
            symbolImageView.image = nil
            kf.setImage(with: URL(string: url)!)
        } else {
            setDefault()
        }
        
    }
    
    func setProfileImage() {
        symbolImageView.image = nil
        guard let imageUrl = User.shared.profilePic else {
            setDefault()
            return
        }
        kf.setImage(with: URL(string: imageUrl)!)
    }
    
    func setDefault() {
        setSymbol(UIImage(systemName: "person.fill"))
        setBackgroundColor(.systemGray5)
        setSymbolColor(.white)
    }
    
    func reset() {
        backgroundColor = .clear
        symbolImageView.image = nil
        symbolImageView.tintColor = .white
        image = nil
    }
    
    func setFollowProfileImage(imageUrl : String){
        symbolImageView.image = nil
        kf.setImage(with: URL(string: imageUrl)!)
    }
    
}
