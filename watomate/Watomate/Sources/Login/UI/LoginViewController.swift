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
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15.adjusted
        return stackView
    }()
    
    private lazy var emailTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "이메일"
        textField.font = UIFont(name: "Pretendard-Medium", size: Constants.Login.textFieldFontSize)
        textField.setPlaceholderColor(.secondaryLabel)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "비밀번호"
        textField.font = UIFont(name: "Pretendard-Medium", size: Constants.Login.textFieldFontSize)
        textField.setPlaceholderColor(.secondaryLabel)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var okButton = {
        let button = CustomButton(title: "확인", titleSize: Constants.Login.buttonFontSize)
        button.setColor(titleColor: .systemGray3)
        button.setBorder(width: 1.adjusted, color: .systemGray5, cornerRadius: 5.adjusted)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var forgetLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Light", size: Constants.Login.infoFontSize)!,
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
        hideKeyboardWhenTappedAround()
    }
    
    private func setupNavigationBar() {
        setTitle("로그인")
        setLeftBackButton()
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Login.topInset)
            make.trailing.leading.equalToSuperview().inset(Constants.Login.horizontalInset)
        }
        
        for textField in [emailTextField, passwordTextField] {
            textField.snp.makeConstraints { make in
                make.height.equalTo(Constants.Login.textFieldHeight)
            }
        }
        
        okButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Login.buttonHeight)
        }
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(okButton)
        stackView.addArrangedSubview(forgetLabel)
        
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
            okButton.setColor(titleColor: .label)
        } else {
            okButton.setColor(titleColor: .systemGray5)
        }
    }

}

