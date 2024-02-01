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
        /*
        viewModel.loadGoals { [weak self] in
            DispatchQueue.main.async {
                self?.updateUIGoals(self?.viewModel.goal ?? [])
            }
        }
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadGoals { [weak self] in
            DispatchQueue.main.async {
                print("Loaded goals: \(self?.viewModel.goal ?? [])")
                self?.updateUIGoals(self?.viewModel.goal ?? [])
            }
        }
    }
    
    private func updateUIGoals(_ goals: [Goal]) {
        goalListView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for goal in goals {
            print(goal)
            let button = createButton(withText: goal.title, withColor: goal.color){
                self.handleGoalSelection(goal)
            }
            goalListView.addArrangedSubview(button)
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

    
    private func createButton(withText text: String, withColor color: String, tapAction: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor(named: color), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .secondarySystemBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        button.addAction(UIAction { _ in tapAction() }, for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

    private func handleGoalSelection(_ goal: Goal) {
        let goalEditVC = GoalEditViewController(goal: goal)
        navigationController?.pushViewController(goalEditVC, animated: false)
    }

    /*
    @objc private func addButtonTapped() {
        let goalCreateVC = GoalCreateViewController()
        navigationController?.pushViewController(goalCreateVC, animated: false)
    }
     */

    

}
