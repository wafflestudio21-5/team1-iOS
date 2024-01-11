//
//  FirstViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/30/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class FirstViewController: UIViewController {
    
    private lazy var titleStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var mainImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "waffle")
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = "wato mate"
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Bold", size: 38)
        return label
    }()
    
    private lazy var subtitleLabel = {
       let label = UILabel()
        label.text = "할 일을 작성, 계획, 관리하세요."
        label.textColor = .label
        label.alpha = 0.8
        label.font = UIFont(name: "Pretendard-Light", size: 16)
        return label
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var guestButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .label
        button.configuration?.baseBackgroundColor = .systemGray6
        button.configuration?.attributedTitle = AttributedString("게스트로 시작", attributes: titleContainer)
        return button
    }()
    
    private lazy var loginButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .label
        button.configuration?.baseBackgroundColor = .systemGray6
        button.configuration?.attributedTitle = AttributedString("로그인", attributes: titleContainer)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinButton = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 16)!,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.secondaryLabel
        ]
        
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = .label
        button.setAttributedTitle(NSAttributedString(string: "가입하기", attributes: attributes), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    

    private func setupLayout() {
        
        view.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.height.width.equalTo(250)
        }
        
        titleStackView.addArrangedSubview(mainImageView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        buttonStackView.addArrangedSubview(guestButton)
        buttonStackView.addArrangedSubview(loginButton)
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(35)
        }
    }
    
    @objc private func loginButtonTapped() {
        let nextViewController = LoginViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    

}
