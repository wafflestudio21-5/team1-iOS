//
//  LikeContainerView.swift
//  Watomate
//
//  Created by 이지현 on 1/31/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum LikeContainerSize {
    case regular
    case small
}

class LikeContainerView: UIView {
    private let size: LikeContainerSize
    
    private lazy var footerView = {
        let view = UIView()
        
        emojiContainerView.snp.makeConstraints { make in
            make.height.equalTo( size == .regular ? Constants.SearchDiary.footerViewHeight : Constants.SearchDiary.footerViewHeight - 3.adjusted)
        }
        
        likeCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(size == .regular ? Constants.SearchDiary.footerViewHeight : Constants.SearchDiary.footerViewHeight - 3.adjusted)
        }
        
        view.addSubview(emojiContainerView)
        emojiContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        view.addSubview(likeCircleView)
        likeCircleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var emojiContainerView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = size == .regular ? 5.adjusted : 3.adjusted
        
        view.addArrangedSubview(emojiLabel1)
        view.addArrangedSubview(emojiLabel2)
        view.addArrangedSubview(emojiCountLabel)
        return view
    }()
    
    private lazy var emojiLabel1 = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: size == .regular ? 18 : 16)
        return label
    }()
    
    private lazy var emojiLabel2 = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: size == .regular ? 18 : 16)
        return label
    }()
    
    private lazy var emojiCountLabel = {
        let label = UILabel()
        label.textColor = .label
        label.isHidden = true
        label.font = .systemFont(ofSize: size == .regular ? 16 : 14, weight: .semibold)
        return label
    }()
    
    private lazy var likeCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "heart.fill"))
        return view
    }()
    
    init(size: LikeContainerSize) {
        self.size = size
        super.init(frame: .zero)
        
        addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLikeTapAction(target: Any?, action: Selector) {
        likeCircleView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        likeCircleView.isUserInteractionEnabled = true
    }
    
    func configure(likes: [SearchLike], color: Color, userId: Int) {
        likeCircleView.setBackgroundColor(color.heartBackground)
        if likes.contains(where: { $0.user == userId }) {
            likeCircleView.setSymbolColor(UIColor(red: 253.0/255.0, green: 93.0/255.0, blue: 93.0/255.0, alpha: 1))
        } else {
            likeCircleView.setSymbolColor(color.heartSymbol)
        }
        
        let likeCount = likes.count
        switch likeCount {
        case 0:
            break
        case 1:
            emojiLabel1.isHidden = false
            emojiLabel1.text = likes[0].emoji
            emojiCountLabel.isHidden = false
            emojiCountLabel.text = "1"
        default:
            emojiLabel1.isHidden = false
            emojiLabel1.text = likes[likeCount - 1].emoji
            emojiLabel2.isHidden = false
            emojiLabel2.text = likes[likeCount - 2].emoji
            emojiCountLabel.isHidden = false
            emojiCountLabel.text = String(likeCount)
        }
        
    }
    
    func reset() {
        likeCircleView.setBackgroundColor(.systemGray6)
        likeCircleView.setSymbolColor(.systemGray4)
        emojiLabel1.isHidden = true
        emojiLabel2.isHidden = true
        emojiCountLabel.isHidden = true
    }
    
}
