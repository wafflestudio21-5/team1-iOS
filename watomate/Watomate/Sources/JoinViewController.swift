//
//  JoinViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/1/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class JoinViewController: PlainCustomBarViewController {

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
    
    private lazy var checkImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        imageView.tintColor = .systemGray5
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
        setTitle("가입하기")
        setLeftBackButton()
        
        setupLayout()
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
        
        contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(35)
            make.height.width.equalTo(23)
        }
        
        contentView.addSubview(checkLabel)
        checkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkImageView.snp.centerY)
            make.leading.equalTo(checkImageView.snp.trailing).offset(6)
        }
    }

}
