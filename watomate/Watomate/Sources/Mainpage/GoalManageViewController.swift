//
//  GoalManageViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class GoalManageViewController: PlainCustomBarViewController {
    var viewModel = GoalManageViewModel(todoUseCase: TodoUseCase(todoRepository: TodoRepository()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("목표")
        setLeftBackButton()
        setRightButtonStyle(symbolName: "plus", title: nil)
        // setRightButtonAction(target: self, action: #selector(addButtonTapped))
        contentView.addSubview(goalListView)
        goalListView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        viewModel.loadGoals { [weak self] in
            DispatchQueue.main.async {
                self?.updateUIGoals(self?.viewModel.goal ?? [])
            }
        }
    }
    
    private lazy var goalListView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()

    
    private func updateUIGoals(_ goals: [Goal]) {
        goalListView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for goal in goals {
            let button = createButton(withText: goal.title) // Assuming each Goal has a title property
            goalListView.addArrangedSubview(button)
        }
    }

    
    private func createButton(withText text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)  // Set the text color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .secondarySystemBackground  // Set the background color
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)

        // Apply capsule shape
        button.layer.cornerRadius = 20  // Assuming a height of 40
        button.clipsToBounds = true

        // Set fixed height
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }





   


    
    /*
    @objc private func addButtonTapped() {
        let goalCreateVC = GoalCreateViewController()
        navigationController?.pushViewController(goalCreateVC, animated: false)
    }
     */

    

}
