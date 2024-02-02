//
//  LoginViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Combine
import UIKit
import SnapKit

class LoginViewController: PlainCustomBarViewController {
    private let viewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
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
        textField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
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
        textField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
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
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        return label
    }()
    
    private lazy var underlineLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: Constants.Login.infoFontSize)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.label
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "비밀번호를 잊었다면?", attributes: attributes)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        bindViewModel()
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
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loginSucceed:
                    self?.transitionToMainScreen()
                case .loginFailed(let errorMessage):
                    self?.showAlert(message: errorMessage)
                case .toggleOkButton(let isEnabled):
                    self?.updateOkButtonState(isEnabled: isEnabled)
                }
            }.store(in: &cancellables)
    }
    
    @objc private func emailDidChange() {
        viewModel.input.send(.emailEdited(email: emailTextField.text ?? ""))
    }
    
    @objc private func passwordDidChange() {
        viewModel.input.send(.passwordEdited(password: passwordTextField.text ?? ""))
    }
    
    @objc private func okButtonTapped() {
        viewModel.input.send(.okButtonTapped)
    }
    
    private func transitionToMainScreen() {
        navigationController?.pushViewController(TabBarController(), animated: true)
    }
    
    private func updateOkButtonState(isEnabled: Bool) {
        okButton.isEnabled = isEnabled
        okButton.setColor(titleColor: isEnabled ? .label : .systemGray5)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default ))
        present(alert, animated: true)
    }

}

