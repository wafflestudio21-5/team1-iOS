//
//  ResultTabBarController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class ResultTabBarController: UITabBarController {
    
    private let searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTabBar()
        setUpTabbarAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height)
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: InitialTodoViewController(), title: "", image: "유저".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialTodoViewController(), title: "", image: "할 일".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialTodoViewController(), title: "", image: "일기".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]))
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
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }

}
