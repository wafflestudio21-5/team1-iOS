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
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupLayout()
    }
    
    private func setupSearchBar() {
        navigationItem.titleView = searchBar
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func clearButtonTapped() {
        searchBar.endEditing(true)
        updateChildViewController(for: searchBar.text)
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        updateChildViewController(for: nil)
    }
    
    private func updateChildViewController(for searchText: String?) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        let childViewController: UIViewController
        
        if let searchText, !searchText.isEmpty {
            childViewController = SearchTabBarController(searchText: searchText)
        } else {
            childViewController = SearchTabBarController(searchText: nil)
        }

        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        childViewController.didMove(toParent: self)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateChildViewController(for: searchBar.text)
    }
    
}
