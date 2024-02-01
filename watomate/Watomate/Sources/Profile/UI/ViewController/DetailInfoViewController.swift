//
//  DetailInfoViewController.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import UIKit

class DetailInfoViewController: UIViewController {
    private let viewModel:ImageCellViewModel
    
    init(viewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        
        view.addArrangedSubview(goalContainerView)
        view.addArrangedSubview(todoLabel)
        return view
    }()
    
    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        
        view.addSubview(goalContainerView)
        goalContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(18)
        }
        
        view.addSubview(todoLabel)
        todoLabel.snp.makeConstraints { make in
            make.top.equalTo(goalContainerView.snp.bottom).offset(12)
            make.trailing.leading.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().inset(20)
        }
        return view
    }()
    
    private lazy var goalContainerView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1)
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        
        view.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(14).priority(999)
        }
        
        view.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(96)
        }
        return view
    }()
    
    private lazy var goalLabel = {
        let label = UILabel()
        label.textColor = Color(rawValue: viewModel.goalColor)?.uiColor ?? .label
        label.font = UIFont(name: Constants.Font.medium, size: 19)
        label.text = viewModel.goalTitle
        return label
    }()
    
    private lazy var todoLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 19)
        label.text = viewModel.todoTitle
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
    }

}
