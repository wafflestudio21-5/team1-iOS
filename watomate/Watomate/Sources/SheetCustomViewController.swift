//
//  SheetCustomViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2024/01/09.
//

import UIKit

class SheetCustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    func setupLayout(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
         }
        view.addSubview(sheetView)
        sheetView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.top.equalTo(sheetView.snp.bottom)
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
        }
        
    }
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var okButton : UIButton = {
        let button = UIButton(type: .system)
   //     button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sheetView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var onDismiss: ((String) -> Void)?
}

extension SheetCustomViewController: UIGestureRecognizerDelegate { }

extension SheetCustomViewController {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func okButtonAction(target: Any, action: Selector) {
        okButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func hideOkButton(){
        okButton.isHidden = true
    }
}
