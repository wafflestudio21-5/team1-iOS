//
//  LoginViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

<<<<<<< HEAD
class LoginViewController: PlainCustomBarViewController {
=======
class LoginViewController: PlainCustomBarViewController {
>>>>>>> frontend/basic-ui
    
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
<<<<<<< HEAD
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()
    
    private lazy var underlineLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0),
=======
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()
    
    private lazy var underlineLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0),
>>>>>>> frontend/basic-ui
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.label
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        setTitle("로그인")
        setLeftBackButton()
        
        emailTextField.becomeFirstResponder()
=======
        setTitle("로그인")
        setLeftBackButton()
        
        emailTextField.becomeFirstResponder()
>>>>>>> frontend/basic-ui
        
        setupLayout()
    }
    
    private func setupLayout() {
<<<<<<< HEAD
        contentView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
=======
        contentView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
>>>>>>> frontend/basic-ui
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
<<<<<<< HEAD
        contentView.addSubview(passwordTextField)
=======
        contentView.addSubview(passwordTextField)
>>>>>>> frontend/basic-ui
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
<<<<<<< HEAD
        contentView.addSubview(okButton)
=======
        contentView.addSubview(okButton)
>>>>>>> frontend/basic-ui
        okButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
<<<<<<< HEAD
        contentView.addSubview(forgetLabel)
=======
        contentView.addSubview(forgetLabel)
>>>>>>> frontend/basic-ui
        forgetLabel.snp.makeConstraints { make in
            make.top.equalTo(okButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
<<<<<<< HEAD
        contentView.addSubview(underlineLabel)
        underlineLabel.snp.makeConstraints { make in
            make.edges.equalTo(forgetLabel.snp.edges)
        }
    }

}
=======
        
        contentView.addSubview(underlineLabel)
        underlineLabel.snp.makeConstraints { make in
            make.edges.equalTo(forgetLabel.snp.edges)
        }
    }

}

>>>>>>> frontend/basic-ui
