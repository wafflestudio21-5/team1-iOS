//
//  SceneDelegate.swift
//  Watomate
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import KakaoSDKAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        
        let userDefaultsRepository = UserDefaultsRepository()
        let isLoggedIn = userDefaultsRepository.get(Bool.self, key: .isLoggedIn) ?? false
        User.shared.isLoggedin = isLoggedIn
        if isLoggedIn {
            getUserInfo()
            window.rootViewController = TabBarController()
        } else {
            let authUseCase = AuthUseCase(authRepository: AuthRepository(), userDefaultsRepository: UserDefaultsRepository(), searchRepository: SearchRepository(), kakaoRepository: KakaoRepository())
            window.rootViewController = UINavigationController(rootViewController: FirstViewController(viewModel: FirstViewModel(authUseCase: authUseCase)))
        }

        window.makeKeyAndVisible()
        self.window = window
        
//        print(User.shared.id)
//        print(User.shared.token)
//        let repo = SearchRepository()
//        let useCase = SearchUseCase(searchRepository: repo)
//        Task {
//            do {
//                try await repo.deleteComment(commentId: 41)
//            } catch {
//                print(error)
//            }
//        }
    }
    
    private func getUserInfo() {
        let userDefaultsRepository = UserDefaultsRepository()
        User.shared.id = userDefaultsRepository.get(Int.self, key: .userId)
        User.shared.token = userDefaultsRepository.get(String.self, key: .accessToken)
        
        Task {
            User.shared.username = userDefaultsRepository.get(String.self, key: .username)
            User.shared.intro = userDefaultsRepository.get(String.self, key: .intro)
            User.shared.profilePic = userDefaultsRepository.get(String.self, key: .profilePic)
            User.shared.followerCount = userDefaultsRepository.get(Int.self, key: .followerCount)
            User.shared.followingCount = userDefaultsRepository.get(Int.self, key: .followingCount)
        }
        
        User.shared.loginMethod = LoginMethod(rawValue: userDefaultsRepository.get(String.self, key: .loginMethod) ?? "")
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
