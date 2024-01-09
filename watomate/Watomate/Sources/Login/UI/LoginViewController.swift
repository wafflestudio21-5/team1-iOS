//
//  LoginViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: PlainCustomBarViewController {
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emailTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "이메일"
        textField.font = UIFont(name: "Pretendard-Medium", size: 20)
        textField.setPlaceholderColor(.secondaryLabel)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "비밀번호"
        textField.font = UIFont(name: "Pretendard-Medium", size: 20)
        textField.setPlaceholderColor(.secondaryLabel)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var okButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Medium", size: Constants.Login.buttonFontSize)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .systemGray3
        button.configuration?.baseBackgroundColor = .systemGray6
        button.configuration?.attributedTitle = AttributedString("확인", attributes: titleContainer)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var forgetLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Light", size: Constants.Login.buttonFontSize - 1)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()
    
    private lazy var underlineLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: Constants.Login.buttonFontSize - 1)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.label
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        observeTextChanges()
    }
    
    private func setupNavigationBar() {
        setTitle("로그인")
        setLeftBackButton()
    }
    
    private func setupLayout() {
        contentView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(forgetLabel)
        forgetLabel.snp.makeConstraints { make in
            make.top.equalTo(okButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(underlineLabel)
        underlineLabel.snp.makeConstraints { make in
            make.edges.equalTo(forgetLabel.snp.edges)
        }
    }
    
    private func observeTextChanges() {
        emailTextField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func emailDidChange(_ textField: UITextField) {
        viewModel.email = textField.text ?? ""
        updateOkButtonState()
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        viewModel.password = textField.text ?? ""
        updateOkButtonState()
    }
    
    @objc private func okButtonTapped() {
        let nextViewController = TabBarController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func updateOkButtonState() {
        okButton.isEnabled = viewModel.canSubmit
        if okButton.isEnabled {
            okButton.configuration?.baseForegroundColor = .label
        }
    }

}

