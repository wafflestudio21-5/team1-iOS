//
//  CustomBarViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/5/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class CustomBarViewController: UIViewController {
    
    private lazy var topInsetView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var navigationBarView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var backButton = {
        let button = UIButton()
        
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: configuration), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 17)
        label.textColor = .label
        return label
    }()
    
    private lazy var plusButton = {
        let button = UIButton()
        
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.tintColor = .label
        button.isHidden = true
        
        return button
    }()
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        setupLayout()
        setupContainerView()
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
        navigationBarView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.leading).offset(35)
            make.centerY.equalToSuperview()
        }
        
        navigationBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        navigationBarView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.trailing).offset(-35)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension CustomBarViewController: UIGestureRecognizerDelegate { }

extension CustomBarViewController {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func showPlusButton() {
        plusButton.isHidden = false
    }
    
    func setPlusButtonAction(target: Any, action: Selector) {
        plusButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
