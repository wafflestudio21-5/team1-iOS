//
//  DraggableCustomBarViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/7/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class DraggableCustomBarViewController: UIViewController {
    
    private var dragIndicatorColor = UIColor.tertiaryLabel
    private var backgroundColor = UIColor.systemBackground
    private var titleAndButtonColor = UIColor.label
    
    private lazy var dragIndicatorContainerView = {
        let view = UIView()
        
        view.addSubview(dragIndicatorView)
        dragIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
        return view
    }()
    
    private lazy var dragIndicatorView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
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
    
    lazy var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()
        setupContainerView()
        setDragIndicatorColor(dragIndicatorColor)
        setBackgroundColor(backgroundColor)
        setTitleAndButtonColor(titleAndButtonColor)
    }
    
    private func setupLayout() {
        view.addSubview(dragIndicatorContainerView)
        dragIndicatorContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(dragIndicatorContainerView.snp.bottom)
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
    }

}

extension DraggableCustomBarViewController {
    
    func setDragIndicatorColor(_ color: UIColor) {
        dragIndicatorColor = color
        dragIndicatorView.backgroundColor = color
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
        dragIndicatorContainerView.backgroundColor = color
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
            rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 18)
        }
        
    }
    
    func setLeftButtonAction(target: Any, action: Selector) {
        leftButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setRightButtonAction(target: Any, action: Selector) {
        rightButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setLeftXButton() {
        setLeftButtonStyle(symbolName: "xmark", title: nil)
        setLeftButtonAction(target: self, action: #selector(xButtonTapped))
    }
    
    @objc private func xButtonTapped() {
        dismiss(animated: true)
    }
    
}


