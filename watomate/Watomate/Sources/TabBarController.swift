//
//  TabBarController.swift
//  WaToMate
//
//  Created by 이수민 on 2023/12/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tabBar.isTranslucent = false
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true 
        
        let todoVC = UINavigationController(rootViewController: ToDoViewController())
        todoVC.tabBarItem = UITabBarItem(title: "피드", image: UIImage(named: "home"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search"), tag: 1)
        

        let groupVC = UINavigationController(rootViewController: GroupViewController())
        groupVC.tabBarItem = UITabBarItem(title: "로그아웃", image: UIImage(systemName: "xmark"), tag: 2)

        let todoRepository = TodoRepository()
        let todoUseCase = TodoUseCase(todoRepository: todoRepository)
        let todoListViewModel = TodoListViewModel(todoUseCase: todoUseCase)
        let profileVC = UINavigationController(rootViewController: ProfileViewController(todoListViewModel: todoListViewModel))

        profileVC.tabBarItem = UITabBarItem(title: "My", image: UIImage(named: "my"), tag: 3)

        viewControllers = [todoVC, searchVC, groupVC, profileVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

