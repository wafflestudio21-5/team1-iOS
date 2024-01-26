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

protocol ProfileEditViewDelegate: AnyObject {
    func showProfileImage(_ image: UIImage?)
}

class ProfileEditViewController: PlainCustomBarViewController {
    weak var delegate: ProfileEditViewDelegate?
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
        
        if let profilePic = User.shared.profilePic {
            view.setProfileImage()
        }
        
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
        field.text = User.shared.username
        field.addTarget(target: self, action: #selector(nameDidChange), for: .editingChanged)
        return field
    }()
    private lazy var descriptionField = {
        let field = LabeledInputView(label: "자기소개", placeholder: "자기소개 입력")
        field.text = User.shared.intro
        field.addTarget(target: self, action: #selector(introDidChange), for: .editingChanged)
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        bindViewModel()
        initViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .okProcessSuccess:
                    self?.navigationController?.popViewController(animated: true)
                case let .okProcessFailed(errorMessage):
                    self?.showAlert(message: errorMessage)
                }
            }.store(in: &cancellables)
    }
    
    private func initViewModel() {
        viewModel.input.send(.usernameEdited(username: nameField.text ?? ""))
        viewModel.input.send(.introEdited(intro: descriptionField.text ?? ""))
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
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default ))
        present(alert, animated: true)
    }

}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileCircleView.setImage(image)
            handleImage(image)
            delegate?.showProfileImage(image)
        }
        dismiss(animated: true)
    }
    
    private func handleImage(_ image: UIImage?) {
        guard let image else { return }
        let resizedImage = image.resizeImage(newWidth: 300)
        viewModel.input.send(.profilePicEdited(imageData: resizedImage.pngData()))
    }
}
