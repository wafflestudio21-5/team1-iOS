//
//  VisibilityViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2024/01/09.
//

import UIKit

class VisibilityViewController: SheetCustomViewController {
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("공개설정")
        sheetView.addSubview(visibilityView)
        visibilityView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(40)
        }
        
        okButtonAction(target: self, action: #selector(okButtonTapped))

    }
    
    @objc private func okButtonTapped() {
        onDismiss?(selectedTitle)
        print(selectedTitle)
        dismiss(animated: true, completion: nil)
    }

    private lazy var visibilityView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        let buttonTitles = ["전체공개", "팔로워 공개", "나만 보기"] //일부공개 제외

        for title in buttonTitles {
            let button = createSelectableButton(title: title)
            stackView.addArrangedSubview(button)
        }

    
        return stackView
    }()
    
    
    func createSelectableButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemCyan, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        button.snp.makeConstraints { make in
            make.height.equalTo(36)
        }

        return button
    }
    
    var selectedTitle : String = ""
    @objc func buttonTapped(_ sender: UIButton) {
        // Unselect the previously selected button
        selectedButton?.isSelected = false

        // Update the selected button
        selectedButton = sender
        selectedButton?.isSelected = true
        selectedTitle = selectedButton?.title(for: .normal) ?? ""
    }
    
    


}
