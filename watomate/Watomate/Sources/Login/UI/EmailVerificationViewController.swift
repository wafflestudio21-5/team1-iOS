//
//  EmailVerificationViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class EmailVerificationViewController: PlainCustomBarViewController {
    var email = "email@naver.com"
    
    private lazy var infoLabel = {
        let label = UILabel()
        label.text = "이메일이 \"\(email)\"로 전송되었습니다. 이메일의 링크를 탭한 후에 아래 \"인증하기\" 버튼을 눌러주세요."
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: "Pretendard-Light", size: 15)
        label.setLineSpacing(spacing: 5)
        return label
    }()
    
    private lazy var verifyButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "Pretendard-Medium", size: Constants.Login.buttonFontSize)
        
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseForegroundColor = .label
        button.configuration?.baseBackgroundColor = .systemGray6
        button.configuration?.attributedTitle = AttributedString("인증하기", attributes: titleContainer)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var emailChangeLabel = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Light", size: Constants.Login.buttonFontSize - 1)!,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "이메일 변경", attributes: attributes)
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
        label.attributedText = NSAttributedString(string: "이메일 변경", attributes: attributes)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("이메일 인증")
        setLeftBackButton()
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(verifyButton)
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        contentView.addSubview(emailChangeLabel)
        emailChangeLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(underlineLabel)
        underlineLabel.snp.makeConstraints { make in
            make.edges.equalTo(emailChangeLabel.snp.edges)
        }
    }

}
