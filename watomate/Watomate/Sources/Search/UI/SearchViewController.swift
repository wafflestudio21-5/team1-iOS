//
//  SearchViewController.swift
//  Watomate
//
//  Created by 이수민 on 2023/12/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "계정 또는 할 일 키워드 검색"
        return searchBar
    }()
    
    private lazy var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let childViewController = InitialTabBarController()
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        childViewController.didMove(toParent: self)
    }
    
    

}
