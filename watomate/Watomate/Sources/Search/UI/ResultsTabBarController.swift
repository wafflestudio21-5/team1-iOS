//
//  ResultsTabBarController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class ResultsTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.layer.backgroundColor = UIColor.systemBackground.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height)
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: InitialUserViewController(), title: "", image: "유저".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialUserViewController(), title: "", image: "할 일".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
            setupVC(viewController: InitialUserViewController(), title: "", image: "일기".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]))
        ]
    }
    
    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }

}
