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
        
        let todoVC = UINavigationController(rootViewController: ToDoViewController())
        todoVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let groupVC = UINavigationController(rootViewController: GroupViewController())
        groupVC.tabBarItem = UITabBarItem(title: "Group", image: UIImage(systemName: "rectangle.3.group.fill"), tag: 2)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)
        
        viewControllers = [todoVC, searchVC, groupVC, profileVC]
    }
}

