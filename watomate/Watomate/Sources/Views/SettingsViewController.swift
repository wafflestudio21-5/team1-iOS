//
//  SettingsViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/8/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class SettingsViewController: PlainCustomBarViewController {
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLeftBackButton()
        self.setTitle("설정")
        
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
