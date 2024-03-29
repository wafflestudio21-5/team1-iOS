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
        
        let todoRepository = TodoRepository()
        let todoUseCase = TodoUseCase(todoRepository: todoRepository)
        let profileTodoListViewModel = TodoListViewModel(todoUseCase: todoUseCase)
        let homeTodoListViewModel = TodoListViewModel(todoUseCase: todoUseCase)
        let diaryViewModel = DiaryPreviewViewModel()
        
        let todoVC = UINavigationController(rootViewController: HomeViewController(todoListViewModel: homeTodoListViewModel, diaryViewModel: diaryViewModel))
        todoVC.tabBarItem = UITabBarItem(title: "피드", image: UIImage(named: "home"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search"), tag: 1)

        let profileVC = UINavigationController(rootViewController: ProfileViewController(todoListViewModel: profileTodoListViewModel))

        profileVC.tabBarItem = UITabBarItem(title: "My", image: UIImage(named: "my"), tag: 3)

        viewControllers = [todoVC, searchVC, profileVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

