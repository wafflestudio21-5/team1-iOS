//
//  GroupViewController.swift
//  Watomate
//
//  Created by 이수민 on 2023/12/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class GroupViewController: UIViewController {
    
    private lazy var button = {
       let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
    }
    
    @objc private func buttonTapped() {
        logout()
        
        let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), searchRepository: SearchRepository(), kakaoRepository: KakaoRepository())
        let vc = UINavigationController(rootViewController: FirstViewController(viewModel: FirstViewModel(authUseCase: authUseCase)))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func logout() {
        if User.shared.loginMethod == .kakao {
            let kakaoRepository = KakaoRepository()
            kakaoRepository.logout()
        }
        let userDefaultsRepository = UserDefaultsRepository()
        userDefaultsRepository.removeAll()
        userDefaultsRepository.set(Bool.self, key: .isLoggedIn, value: false)
    }
    

}
