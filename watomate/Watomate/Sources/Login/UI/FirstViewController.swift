//
//  FirstViewController.swift
//  Waffle
//
//  Created by 이지현 on 12/30/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

class FirstViewController: UIViewController {
    private let viewModel: FirstViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FirstViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleContainerView = UIView()
    
    private lazy var titleStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10.adjusted
        return stackView
    }()
    
    private lazy var mainImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main")
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = "wato mate"
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Bold", size: Constants.First.titleFontSize)
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var subtitleLabel = {
       let label = UILabel()
        label.text = "할 일을 작성, 계획, 관리하세요."
        label.textColor = .label
        label.alpha = 0.8
        label.font = UIFont(name: "Pretendard-Light", size: Constants.First.subtitleFontSize)
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.adjusted
        return stackView
    }()
    
    private lazy var kakaoLoginButton = {
        let button = CustomButton(title: "카카오 로그인", titleSize: Constants.First.buttonFontSize)
        button.setColor(backgroundColor: .systemBackground, titleColor: .label)
        button.setBorder(width: 2.adjusted, color: .systemGray5, cornerRadius: 8.adjusted)
        button.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var horizontalButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5.adjusted
        return stackView
    }()
    
    private lazy var guestButton =
    {
        let button = CustomButton(title: "게스트로 시작", titleSize: Constants.First.buttonFontSize)
        button.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton = {
        let button = CustomButton(title: "로그인", titleSize: Constants.First.buttonFontSize)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinButton = {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: Constants.First.buttonFontSize)!,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.secondaryLabel
        ]
        
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = .label
        button.setAttributedTitle(NSAttributedString(string: "가입하기", attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
        bindViewModel()
    }
    

    private func setupLayout() {
        
        setupButtons()
        setupTitleView()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .kakaoLoginSuceed, .guestLoginSuceed:
                    self?.transitionToMainScreen()
                case .guestLoginFailed(let errorMessage):
                    self?.showAlert(message: errorMessage)
                case .kakaoLoginFailed(let errorMessage):
                    self?.showAlert(message: "Kakao login Failed")
                }
            }.store(in: &cancellables)
    }
    
    private func setupButtons() {
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.First.bottomInset)
            make.leading.trailing.equalToSuperview().inset(Constants.First.horizontalInset)
        }
        
        horizontalButtonStackView.addArrangedSubview(guestButton)
        horizontalButtonStackView.addArrangedSubview(loginButton)
        
        for view in [kakaoLoginButton, horizontalButtonStackView, joinButton] {
            view.snp.makeConstraints { make in
                make.height.equalTo(Constants.First.buttonHeight)
            }
        }
        
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        buttonStackView.addArrangedSubview(horizontalButtonStackView)
        buttonStackView.addArrangedSubview(joinButton)
    }
    
    private func setupTitleView() {
        view.addSubview(titleContainerView)
        titleContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(buttonStackView.snp.top)
        }
        
        titleContainerView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.First.imageViewSize)
        }
        
        titleStackView.addArrangedSubview(mainImageView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
    }
    
    @objc private func loginButtonTapped() {
        let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), kakaoRepository: KakaoRepository())
        let nextViewController = LoginViewController(viewModel: LoginViewModel(authUseCase: authUseCase))
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), kakaoRepository: KakaoRepository())
        let nextViewController = JoinViewController(viewModel: JoinViewModel(authUseCase: authUseCase))
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func guestButtonTapped() {
        viewModel.input.send(.guestLoginTapped)
    }
    
    
    @objc private func kakaoLoginTapped() {
        viewModel.input.send(.kakaoLoginTapped)
    }
    
    private func transitionToMainScreen() {
        navigationController?.pushViewController(TabBarController(), animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default ))
        present(alert, animated: true)
    }

}
