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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
    }

}
