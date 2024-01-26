//
//  ProfileEditViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import UIKit
import SnapKit

class ProfileEditViewController: PlainCustomBarViewController {
    private let viewModel: ProfileEditViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var nameField = {
       let field = LabeledInputView(label: "이름", placeholder: "이름 입력")
//        field.text = User.shared.username
        field.addTarget(target: self, action: #selector(nameDidChange), for: .editingChanged)
        return field
    }()
    private lazy var descriptionField = {
        let field = LabeledInputView(label: "자기소개", placeholder: "자기소개 입력")
        // 나중에 인트로 수정
//        field.text = User.shared.intro
        field.addTarget(target: self, action: #selector(introDidChange), for: .editingChanged)
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.text = User.shared.username
        // 인트로 처리해야함
        setupNavigationBar()
        setupLayout()
        
        print(User.shared.id)
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
    
    @objc private func cameraTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func nameDidChange() {
        viewModel.input.send(.usernameEdited(username: nameField.text ?? ""))
    }
    
    @objc private func introDidChange() {
        viewModel.input.send(.introEdited(intro: descriptionField.text ?? ""))
    }
    
    @objc private func okButtonTapped() {
        viewModel.input.send(.okButtonTapped)
        navigationController?.popViewController(animated: true)
    }

}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileCircleView.setImage(image)
            handleImage(image)
        }
        dismiss(animated: true)
    }
    
    private func handleImage(_ image: UIImage?) {

        viewModel.input.send(.profilePicEdited(imageData: image?.pngData()))
    }
}
