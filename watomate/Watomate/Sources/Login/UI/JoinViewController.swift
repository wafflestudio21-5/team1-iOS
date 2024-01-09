//
//  JoinViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/1/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import Alamofire

class JoinViewController: PlainCustomBarViewController {
    private let viewModel: JoinViewModel
    
    init(viewModel: JoinViewModel) {
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
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
    
    private lazy var infoLabel = {
        let label = UILabel()
        label.text = """
        가입하면:
        • 다른 기기에서 로그인 가능합니다.
        • 다른 사용자들과 함께할 수 있습니다.
        
        가입과 동시에 와투메이트의 이용약관과 개인정보 정책에 동의하는 것으로 간주합니다.
        """
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Light", size: 15)
        label.setLineSpacing(spacing: 5)
        return label
    }()
    
    private lazy var checkContainerView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
    
        stackView.addArrangedSubview(checkImageView)
        stackView.addArrangedSubview(checkLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        return stackView
    }()
    
    private lazy var checkImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(23)
        }
        
        return imageView
    }()
    
    private lazy var checkLabel = {
        let label = UILabel()
        label.text = "저는 14세 이상입니다"
        label.font = UIFont(name: "Pretendard-Light", size: 15)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
        observeTextChanges()
    }
    
    private func setupNavigationBar() {
        setTitle("가입하기")
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
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(okButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(checkContainerView)
        checkContainerView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
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
    
    @objc private func checkTapped() {
        viewModel.isChecked.toggle()
        let isChecked = viewModel.isChecked
        if isChecked {
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            checkImageView.tintColor = .label
        } else {
            checkImageView.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            checkImageView.tintColor = .systemGray5
        }
        checkImageView.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        updateOkButtonState()
    }
    
    @objc private func okButtonTapped() {
//        Task {
//            let result = viewModel.signUp()
//            if result {
//                let nextViewController = ProfileEditViewController()
//                navigationController?.pushViewController(nextViewController, animated: true)
//            }
//        }
        navigationController?.setViewControllers([TabBarController(), ProfileEditViewController()], animated: true)
    }
    
    private func updateOkButtonState() {
        okButton.isEnabled = viewModel.canSubmit
        if okButton.isEnabled {
            okButton.configuration?.baseForegroundColor = .label
        }
    }

}

