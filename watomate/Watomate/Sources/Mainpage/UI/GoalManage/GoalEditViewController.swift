//
//  GoalEditViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class GoalEditViewController: PlainCustomBarViewController {
    var viewModel = GoalManageViewModel(todoUseCase: TodoUseCase(todoRepository: TodoRepository()))
    var goal : Goal
    var goalVisibility: Visibility? = nil
    var goalColor : String? = nil
    
    init(goal: Goal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    @objc private func okButtonTapped() {
        let goalId = goal.id
        let entry = GoalCreate(
            title: goalTitleView.text ?? goal.title,
            visibility: goalVisibility?.rawValue ?? "PB",
            color: goalColor ?? "blue"
        )
        print(entry)
        viewModel.patchGoal(goalId, goal: entry) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedGoal):
                    print("Goal updated \(updatedGoal)")
                case .failure(let error):
                    print("Error updating goal: \(error)")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("목표")
        setLeftBackButton()
        setRightButtonStyle(symbolName: nil, title: "확인")
        setRightButtonAction(target: self, action: #selector(okButtonTapped))
        setupLayout()
        updateUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goalTitleView.layer.addBorder(color: UIColor(named: goalColor ?? "systemGray") ?? .systemGray4, width: 2.0)
        goalVisibilityButton.layer.addBorder(color: .systemGray4, width: 1.0)
        goalColorButton.layer.addBorder(color: .systemGray4, width: 1.0)
    }

    private func updateUI(){
        goalTitleView.text = goal.title
        goalVisibility = goal.visibility
        updateVisibilityButtonAppearance()
        goalColor = goal.color
        updateGoalColor()
        goalTitleView.layer.addBorder(color: UIColor(named: goalColor ?? "systemGray") ?? .systemGray4, width: 2.0)
        
    }
    
    private lazy var goalEditView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        
        stackView.addArrangedSubview(goalTitleView)
        stackView.addArrangedSubview(goalVisibilityButton)
        stackView.addArrangedSubview(goalColorButton)
        stackView.addArrangedSubview(goalDeleteButton)
        
        return stackView
    }()
    
    private func setupLayout(){
        contentView.addSubview(goalEditView)
        goalEditView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        goalTitleView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        goalVisibilityButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        goalColorButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        goalDeleteButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    private lazy var goalTitleView: UITextField = {
        let textfield = UITextField()
        return textfield
    }()
    
    func visibilityFromString(_ string: String) -> Visibility? {
        switch string {
        case "전체공개":
            return .PB
        case "팔로워 공개":
            return .FL
        case "나만 보기":
            return .PR
        default:
            return nil
        }
    }
    
    @objc private func visibilityButtonTapped() {
        let vc = VisibilityViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = {data in
            if let selectedVisibility = self.visibilityFromString(data) {
                self.goalVisibility = selectedVisibility
                self.updateVisibilityButtonAppearance()
            } else {
                print("Invalid visibility value: \(data)")
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func updateVisibilityButtonAppearance() {
        switch goalVisibility {
        case .PB:
            boxView.image = UIImage(named: "pb")
            goalVisibilityLabel.text = "전체공개"
        case .PR:
            boxView.image = UIImage(named: "pr")
            goalVisibilityLabel.text = "나만 보기"
        case .FL:
            boxView.image = UIImage(named: "fl")
            goalVisibilityLabel.text = "팔로워 공개"
        case .none:
            boxView.image = UIImage(named: "pb")
            goalVisibilityLabel.text = "전체공개"
        } // 어떻게 처리하지
    }
    
    private lazy var goalVisibilityButton: UIButton = {
        let button = UIButton()
        button.setTitle("공개설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addSubview(goalVisibilityView)
        goalVisibilityView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(4)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        button.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goalVisibilityView: UIView = {
        let view = UIView()
        view.addSubview(boxView)
        boxView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        view.addSubview(goalVisibilityLabel)
        goalVisibilityLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(boxView.snp.trailing)
        }
        return view
    }()
    
    private lazy var boxView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var goalVisibilityLabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    @objc private func goalColorButtonTapped() {
        let vc = ColorViewController()
        vc.useGoalColors = true
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            self.goalColor = data
            self.updateGoalColor()
        }
        present(vc, animated: true, completion: nil)
    }

    private func updateGoalColor() {
        goalColorView.backgroundColor = UIColor(named: goalColor ?? "black")
        
        goalTitleView.layer.addBorder(color: UIColor(named: goalColor ?? "black") ?? .black, width: 2.0)
    }
                                    
    
    private lazy var goalColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("색상", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addSubview(goalColorView)
        goalColorView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(4)
            make.width.equalToSuperview().multipliedBy(0.1)
            
        }
        button.addTarget(self, action: #selector(goalColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goalColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    @objc private func goalDeleteButtonTapped() {
        let goalId = goal.id
        viewModel.deleteGoal(goalId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Goal deleted")
                case .failure(let error):
                    print("Error deleting goal: \(error)")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var goalDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemGray4
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goalDeleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
}

extension CALayer {
    func addBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        border.borderWidth = width
        addSublayer(border)
    }
}


