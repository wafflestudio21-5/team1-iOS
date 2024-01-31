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
        
        let todoRepository = TodoRepository()
        let todoUseCase = TodoUseCase(todoRepository: todoRepository)
        let todoListViewModel = TodoListViewModel(todoUseCase: todoUseCase)
        let diaryViewModel = DiaryPreviewViewModel()
        
        let todoVC = UINavigationController(rootViewController: HomeViewController(todoListViewModel: todoListViewModel, diaryViewModel: diaryViewModel))
        todoVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        

        let groupVC = UINavigationController(rootViewController: GroupViewController())
        groupVC.tabBarItem = UITabBarItem(title: "Group", image: UIImage(systemName: "rectangle.3.group.fill"), tag: 2)

        let profileVC = UINavigationController(rootViewController: ProfileViewController(todoListViewModel: todoListViewModel))

        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)

        viewControllers = [todoVC, searchVC, groupVC, profileVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

