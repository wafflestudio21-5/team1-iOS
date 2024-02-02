//
//  PlainCustomBarViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/5/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class PlainCustomBarViewController: UIViewController {
    
    private var backgroundColor = UIColor.systemBackground
    private var titleAndButtonColor = UIColor.label
    
    private lazy var topInsetView = UIView()
    
    private lazy var navigationBarView = UIView()
    
    private lazy var leftButton = {
        let button = UIButton()
        button.isHidden = true
        return button
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 17)
        return label
    }()
    
    private lazy var rightButton = {
       let button = UIButton()
        button.isHidden = true
        return button
    }()
    
    private lazy var followButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: Constants.Font.semiBold, size: 15)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.attributedTitle = AttributedString("팔로우", attributes: titleContainer)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    lazy var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        setupLayout()
        setupContainerView()
        setAllColor(backgroundColor)
        setTitleAndButtonColor(titleAndButtonColor)
    }
    
    private func setupLayout() {
        view.addSubview(topInsetView)
        topInsetView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(topInsetView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func setupContainerView() {
        navigationBarView.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        navigationBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        navigationBarView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
        
        navigationBarView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }

}

extension PlainCustomBarViewController: UIGestureRecognizerDelegate { }

extension PlainCustomBarViewController {
    
    func setAllColor(_ color: UIColor) {
        backgroundColor = color
        topInsetView.backgroundColor = color 
        navigationBarView.backgroundColor = color
        contentView.backgroundColor = color
    }
    
    func setTitleAndButtonColor(_ color: UIColor) {
        titleAndButtonColor = color
        titleLabel.textColor = color
        rightButton.tintColor = color
        rightButton.setTitleColor(color, for: .normal)
        leftButton.tintColor = color
        leftButton.setTitleColor(color, for: .normal)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setLeftButtonStyle(symbolName: String?, title: String?) {
        leftButton.isHidden = false
        
        if let symbolName {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            leftButton.setImage(UIImage(systemName: symbolName, withConfiguration: configuration), for: .normal)
        }
        
        if let title {
            leftButton.setTitle(title, for: .normal)
            leftButton.setTitleColor(.label, for: .normal)
            leftButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 18)
        }
    }
    
    func setRightButtonStyle(symbolName: String?, title: String?) {
        rightButton.isHidden = false
        
        if let symbolName {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            rightButton.setImage(UIImage(systemName: symbolName, withConfiguration: configuration), for: .normal)
        }
        
        if let title {
            rightButton.setTitle(title, for: .normal)
            rightButton.setTitleColor(.label, for: .normal)
            rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 18)
        }
        
    }
    
    func setLeftButtonAction(target: Any, action: Selector) {
        leftButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setRightButtonAction(target: Any, action: Selector) {
        rightButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setLeftBackButton() {
        setLeftButtonStyle(symbolName: "chevron.backward", title: nil)
        setLeftButtonAction(target: self, action: #selector(backButtonTapped))
    }
    
    func setLeftBackXButton() {
        setLeftButtonStyle(symbolName: "xmark", title: nil)
        setLeftButtonAction(target: self, action: #selector(xButtonTapped))
    }
    
    func setLeftBackXNavigateButton() {
        setLeftButtonStyle(symbolName: "xmark", title: nil)
        setLeftButtonAction(target: self, action: #selector(backButtonTapped))
    }
    
    func setFollowButton() {
        followButton.isHidden = false 
    }
    
    func setFollowAction(target: Any, action: Selector) {
        followButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func xButtonTapped() {
        dismiss(animated: true)
    }
    
}


