//
//  ResultUserViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/23/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import UIKit

class ResultUserViewController: UIViewController {
    private let searchText: String
    private let viewModel: ResultUserViewModel
    private var userListDataSource: UITableViewDiffableDataSource<ResultUserSection, UserCellViewModel.ID>!

    private var cancellables = Set<AnyCancellable>()
    
    init(searchText: String, viewModel: ResultUserViewModel) {
        self.searchText = searchText
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
