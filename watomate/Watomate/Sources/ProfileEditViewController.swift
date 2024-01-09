//
//  ProfileEditViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class ProfileEditViewController: PlainCustomBarViewController {
    
    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(profileContainerView)
        profileContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(90)
        }
        return view
    }()
    
    private lazy var profileContainerView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(profileCircleView)
        profileCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(cameraCircleView)
        cameraCircleView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(30)
        }
        return view
    }()
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var cameraCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "camera.fill"))
        view.setBackgroundColor(.systemGray2)
        view.setSymbolColor(.systemBackground)
        view.traitCollection.performAsCurrent {
            view.addBorder(width: 2, color: .systemBackground)
        }
        return view
    }()
    
    private lazy var nameField = LabeledInputView(label: "이름", placeholder: "이름 입력")
    private lazy var descriptionField = LabeledInputView(label: "자기소개", placeholder: "자기소개 입력 (최대 50글자)")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        setTitle("프로필")
        setLeftBackButton()
        setRightButtonStyle(symbolName: nil, title: "확인")
        setRightButtonAction(target: self, action: #selector(okButtonTapped))
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(160)
        }
        
        contentView.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35)
            make.top.equalTo(containerView.snp.bottom)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(descriptionField)
        descriptionField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35)
            make.top.equalTo(nameField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func okButtonTapped() {
        
    }

}
