//
//  UserTodoViewController.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class UserTodoViewController: PlainCustomBarViewController {
    var viewModel: UserTodoViewModel
    
    init(viewModel: UserTodoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBackXButton()
        addChildViewController()
    }
    
    private func addChildViewController() {
        let childViewController = UserTodoTableViewController(viewModel: viewModel)

        addChild(childViewController)
        contentView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        childViewController.didMove(toParent: self)
    }
    

}
