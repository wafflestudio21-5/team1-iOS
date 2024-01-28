//
//  TodoDetailViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/26/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

protocol TodoDetailViewDelegate: AnyObject {
    func deleteTodoCell(with viewModel: TodoCellViewModel)
}

class TodoDetailViewController: SheetCustomViewController {
    private var viewModel: TodoCellViewModel
    var delegate: TodoDetailViewDelegate?
    
    init(viewModel: TodoCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var detailStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var editDeleteStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var editTitleButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        let image = UIImage(systemName: "pencil.line")
        button.setImage(image, for: .normal)
        button.configuration = .plain()
        button.configuration?.imagePlacement = .top
        button.configuration?.imagePadding = 10
        return button
    }()

    private lazy var deleteTodoButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        let image = UIImage(systemName: "trash.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.configuration = .plain()
        button.configuration?.imagePlacement = .top
        button.configuration?.imagePadding = 10
        return button
    }()
    
    private lazy var cellStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var memoCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("메모")
        cellView.setIcon(UIImage(systemName: "note.text")!)
        cellView.setIconBackgroundColor(.systemYellow)
        return cellView
    }()
    
    private lazy var memoTextField = {
        // need to change to textView to support multiline
        let textField = UITextField()
        textField.placeholder = "할 일의 메모를 작성해주세요.\n작성된 메모는 본인만 볼 수 있어요."
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        let paddingView = UIView(frame: .init(x: 0, y: 0, width: 16, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.isHidden = true
        return textField
    }()
    
    private lazy var timeCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("시간 알림")
        cellView.setIcon(UIImage(systemName: "clock.fill")!)
        cellView.setIconBackgroundColor(.systemPink)
        return cellView
    }()
    
    private lazy var doTodayCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("오늘하기")
        cellView.setIcon(UIImage(systemName: "arrow.down")!)
        cellView.setIconBackgroundColor(.systemPurple)
        return cellView
    }()
    
    private lazy var doTomorrowCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("내일 하기")
        cellView.setIcon(UIImage(systemName: "arrow.right")!)
        cellView.setIconBackgroundColor(.systemPurple)
        return cellView
    }()
    
    private lazy var changeDateCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("날짜 바꾸기")
        cellView.setIcon(UIImage(systemName: "arrow.right")!)
        cellView.setIconBackgroundColor(.systemPurple)
        return cellView
    }()
    
    private lazy var moveToArchiveCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("보관함으로 이동")
        cellView.setIcon(UIImage(systemName: "checkmark.rectangle.stack.fill")!)
        cellView.setIconBackgroundColor(.systemPurple)
        return cellView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: viewModel)
        hideOkButton()
        setupDetailViewLayout()
    }
    
    func setupDetailViewLayout() {
        sheetView.addSubview(detailStackView)
        
        detailStackView.addArrangedSubview(editDeleteStackView)
        detailStackView.addArrangedSubview(cellStackView)
        
        editDeleteStackView.addArrangedSubview(editTitleButton)
        editDeleteStackView.addArrangedSubview(deleteTodoButton)
        
        cellStackView.addArrangedSubview(memoCell)
        cellStackView.addArrangedSubview(memoTextField)
        cellStackView.addArrangedSubview(timeCell)
        cellStackView.addArrangedSubview(doTodayCell)
        cellStackView.addArrangedSubview(doTomorrowCell)
        cellStackView.addArrangedSubview(changeDateCell)
        cellStackView.addArrangedSubview(moveToArchiveCell)
        
        detailStackView.snp.makeConstraints { make in
            make.edges.equalTo(sheetView.safeAreaLayoutGuide).inset(20)
        }
        
        editTitleButton.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    func configure(with viewModel: TodoCellViewModel) {
        setTitle(viewModel.title)
        if viewModel.memo?.isEmpty == false {
            memoTextField.isHidden = false
        }
        deleteTodoButton.addTarget(self, action: #selector(handleDeleteBtnTap), for: .touchUpInside)
    }
    
    @objc func handleDeleteBtnTap() {
        delegate?.deleteTodoCell(with: viewModel)
        dismiss(animated: true)
    }
}
