//
//  LoginViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private lazy var emailTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "이메일"
        textField.font = UIFont(name: "Pretendard-Medium", size: 20)
        textField.setPlaceholderColor(.secondaryLabel)
        return textField
    }()
    
    private lazy var passwordTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "비밀번호"
        textField.font = UIFont(name: "Pretendard-Medium", size: 20)
        textField.setPlaceholderColor(.secondaryLabel)
        return textField
    }()
    
    private lazy var okButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Medium", size: 18)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .systemGray3
        button.configuration?.baseBackgroundColor = .systemGray6
        button.configuration?.attributedTitle = AttributedString("확인", attributes: titleContainer)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var forgetLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Light", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.label
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "로그인"
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        view.addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        view.addSubview(forgetLabel)
        forgetLabel.snp.makeConstraints { make in
            make.top.equalTo(okButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

}
