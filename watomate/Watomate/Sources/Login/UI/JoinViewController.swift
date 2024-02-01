//
//  JoinViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/1/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Combine
import UIKit

protocol JoinViewControllerDelegate: AnyObject {
    func guestJoinComplete()
}

class JoinViewController: PlainCustomBarViewController {
    weak var delegate: JoinViewControllerDelegate?
    private let viewModel: JoinViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: JoinViewModel) {
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
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
        label.font = UIFont(name: "Pretendard-Light", size: Constants.Login.infoFontSize)
        label.setLineSpacing(spacing: 5.adjusted)
        return label
    }()
    
    private lazy var checkContainerView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6.adjusted
    
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
            make.height.width.equalTo(23.adjusted)
        }
        
        return imageView
    }()
    
    private lazy var checkLabel = {
        let label = UILabel()
        label.text = "저는 14세 이상입니다"
        label.font = UIFont(name: "Pretendard-Light", size: Constants.Login.infoFontSize)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupNavigationBar() {
        setTitle("가입하기")
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
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(checkContainerView)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .signupSucceed:
                    self?.transitionToMainScreen()
                case .signupFailed(let errorMessage):
                    self?.showAlert(message: errorMessage)
                case .toggleCheckButton(let isChecked):
                    self?.updateCheckmarkStatus(isChecked: isChecked)
                case .toggleOkButton(let isEnabled):
                    self?.updateOkButtonState(isEnabled: isEnabled)
                case .guestSignUpSucceed:
                    self?.popController()
                }
            }.store(in: &cancellables)
    }
    
    @objc private func emailDidChange() {
        viewModel.input.send(.emailEdited(email: emailTextField.text ?? ""))
    }
    
    @objc private func passwordDidChange() {
        viewModel.input.send(.passwordEdited(password: passwordTextField.text ?? ""))
    }
    
    @objc private func checkTapped() {
        viewModel.input.send(.checkButtonTapped)

    }
    
    @objc private func okButtonTapped() {
        viewModel.input.send(.okButtonTapped)
    }
    
    private func popController() {
        navigationController?.popViewController(animated: true)
        delegate?.guestJoinComplete()
    }
    
    private func transitionToMainScreen() {
        navigationController?.setViewControllers([TabBarController(), ProfileEditViewController(viewModel: ProfileEditViewModel(userUseCase: UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())))], animated: true)
    }
    
    private func updateOkButtonState(isEnabled: Bool) {
        okButton.isEnabled = isEnabled
        okButton.setColor(titleColor: isEnabled ? .label : .systemGray5)
    }
    
    private func updateCheckmarkStatus(isChecked: Bool) {
        if isChecked {
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            checkImageView.tintColor = .label
        } else {
            checkImageView.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            checkImageView.tintColor = .systemGray5
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default ))
        present(alert, animated: true)
    }

}

