//
//  SearchTabBarController.swift
//  Watomate
//
//  Created by 이지현 on 1/21/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class SearchTabBarController: UITabBarController {
    
    private let searchText: String?
    
    init(searchText: String?) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let searchUseCase = SearchUseCase(searchRepository: SearchRepository())
        
        if let searchText {
            viewControllers = [
                setupVC(
                    viewController: UserFeedViewController(searchText: searchText, viewModel: UserFeedViewModel(searchUserCase: searchUseCase)),
                        title: "",
                        image: "계정".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
                setupVC(
                    viewController: TodoFeedViewController(searchText: searchText, viewModel: TodoFeedViewModel(searchUserCase: searchUseCase)),
                        title: "",
                        image: "할 일".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]))
            ]
        } else {
            viewControllers = [
                setupVC(
                    viewController: UserFeedViewController(searchText: nil, viewModel: UserFeedViewModel(searchUserCase: searchUseCase)),
                    title: "",
                    image: "계정".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
                setupVC(
                    viewController: TodoFeedViewController(searchText: nil, viewModel: TodoFeedViewModel(searchUserCase: searchUseCase)),
                    title: "",
                    image: "할 일".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])),
                setupVC(
                    viewController: DiaryFeedViewController(viewModel: DiaryFeedViewModel(searchUserCase: searchUseCase)),
                    title: "",
                    image: "일기".image(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]))
            ]
        }
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
