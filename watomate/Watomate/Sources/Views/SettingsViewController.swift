//
//  SettingsViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/8/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class SettingsViewController: PlainCustomBarViewController {
    private let items = ["프로필 설정", "로그아웃", "계정 삭제하기"]
    private lazy var functions = [profileFunc, logoutFunc, deleteFunc]
    
    private let guestItems = ["가입하기", "프로필 설정", "계정 삭제하기"]
    private lazy var guestFunctions = [guestLoginFunc, profileFunc, deleteFunc]
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = .tertiaryLabel
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLeftBackButton()
        self.setTitle("설정")
        
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var guestLoginFunc = { [weak self] in
        let vc = JoinViewController(viewModel: JoinViewModel(authUseCase: AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), searchRepository: SearchRepository(), kakaoRepository: KakaoRepository())))
        vc.delegate = self
        self?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var profileFunc = {[weak self] in
        let vc = ProfileEditViewController(viewModel: ProfileEditViewModel(userUseCase: UserUseCase(userRepository: UserRepository(), userDefaultsRepository: UserDefaultsRepository())))
        self?.navigationController?.pushViewController(vc, animated: true) 
    }
    
    private lazy var logoutFunc = { [weak self] in
        self?.logout()
        
        let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), searchRepository: SearchRepository(), kakaoRepository: KakaoRepository())
        let vc = UINavigationController(rootViewController: FirstViewController(viewModel: FirstViewModel(authUseCase: authUseCase)))
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: false)
    }
    
    private func logout() {
        if User.shared.loginMethod == .kakao {
            let kakaoRepository = KakaoRepository()
            kakaoRepository.logout()
        }
        let userDefaultsRepository = UserDefaultsRepository()
        userDefaultsRepository.removeAll()
        userDefaultsRepository.set(Bool.self, key: .isLoggedIn, value: false)
    }
    private lazy var deleteFunc = { [weak self] in
        self?.showAlert(message: "계정을 삭제하시겠습니까?", handler: self?.showDoubleCheck)
    }
    
    private func showDoubleCheck(action: UIAlertAction) {
        showAlert(message: "정말 계정을 삭제하시겠습니까? 모든 정보가 완전히 삭제됩니다.", handler: deleteAccount)
    }
    
    private func deleteAccount(action: UIAlertAction) {
        let authRepo = AuthRepository()
        Task {
            try await authRepo.deleteAccount() // 왜 에러가 안나지?
            
            logout()
            
            let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), searchRepository: SearchRepository(), kakaoRepository: KakaoRepository())
            let vc = UINavigationController(rootViewController: FirstViewController(viewModel: FirstViewModel(authUseCase: authUseCase)))
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
            
        }

    }
    
    private func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
        present(alert, animated: true)
    }
    
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        User.shared.loginMethod == .guest ? guestItems.count : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = User.shared.loginMethod == .guest ? guestItems[indexPath.row] : items[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        if indexPath.row == 2 {
            cell.textLabel?.textColor = .systemRed
        } else {
            cell.textLabel?.textColor = .label
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        User.shared.loginMethod == .guest ? guestFunctions[indexPath.row]() : functions[indexPath.row]()
    }
    
    
}

extension SettingsViewController: JoinViewControllerDelegate {
    func guestJoinComplete() {
        tableView.reloadData()
    }
    
    
}
