//
//  InitialTabBarController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class InitialTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        tabBar.backgroundColor = .systemBackground
        
        setupTabBar()
        setUpTabbarAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height)
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: InitialUserViewController(viewModel: InitialUserViewModel(searchUserCase: SearchUseCase(searchRepository: SearchRepository()))), title: "", image: "계정".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialTodoViewController(), title: "", image: "할 일".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialDiaryViewController(viewModel: InitialDiaryViewModel(searchUserCase: SearchUseCase(searchRepository: SearchRepository()))), title: "", image: "일기".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]))
        ]
    }
    
    private func setUpTabbarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.tintColor = .label
    }
    
    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let VC = UINavigationController(rootViewController: viewController)
        VC.tabBarItem.title = title
        VC.tabBarItem.image = image
        return VC
    }

}
