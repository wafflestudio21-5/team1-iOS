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
    func didEndEditingMemo(viewModel: TodoCellViewModel)
    func editTitle(with viewModel: TodoCellViewModel)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMemoCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleMemoCellTap), for: .touchUpInside)
        cellView.addButtonTarget(self, action: #selector(handleDoneBtnTap), event: .touchUpInside)
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
        textField.delegate = self
        return textField
    }()
    
    private lazy var reminderCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("시간 알림")
        cellView.setIcon(UIImage(systemName: "clock.fill")!)
        cellView.setIconBackgroundColor(.systemPink)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleReminderCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleReminderCellTap), for: .touchUpInside)
        return cellView
    }()
    
    private lazy var doTodayCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("오늘하기")
        cellView.setIcon(UIImage(systemName: "arrow.down")!)
        cellView.setIconBackgroundColor(.systemPurple)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoTodayCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleDoTodayCellTap), for: .touchUpInside)
        return cellView
    }()
    
    private lazy var doTomorrowCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("내일 하기")
        cellView.setIcon(UIImage(systemName: "arrow.right")!)
        cellView.setIconBackgroundColor(.systemPurple)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoTomorrowCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleDoTomorrowCellTap), for: .touchUpInside)
        return cellView
    }()
    
    private lazy var changeDateCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("날짜 바꾸기")
        cellView.setIcon(UIImage(systemName: "arrow.right")!)
        cellView.setIconBackgroundColor(.systemPurple)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChangeDateCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleChangeDateCellTap), for: .touchUpInside)
        return cellView
    }()
    
    private lazy var moveToArchiveCell = {
        let cellView = TodoDetailCellView()
        cellView.setTitle("보관함으로 이동")
        cellView.setIcon(UIImage(systemName: "checkmark.rectangle.stack.fill")!)
        cellView.setIconBackgroundColor(.systemPurple)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToArchiveCellTap))
        cellView.addGestureRecognizer(tapGesture)
        cellView.icon.addTarget(self, action: #selector(handleMoveToArchiveCellTap), for: .touchUpInside)
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
        cellStackView.addArrangedSubview(reminderCell)
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
            memoTextField.text = viewModel.memo
        }
        editTitleButton.addTarget(self, action: #selector(handleEditBtnTap), for: .touchUpInside)
        deleteTodoButton.addTarget(self, action: #selector(handleDeleteBtnTap), for: .touchUpInside)
    }
    
    @objc func handleEditBtnTap() {
        delegate?.editTitle(with: viewModel)
        dismiss(animated: true)
    }
    
    @objc func handleDeleteBtnTap() {
        delegate?.deleteTodoCell(with: viewModel)
        dismiss(animated: true)
    }
    
    @objc func handleMemoCellTap() {
        memoTextField.isHidden = false
        memoTextField.becomeFirstResponder()
        memoCell.showDoneBtn()
    }
    
    @objc func handleDoneBtnTap() {
        if let memo = memoTextField.text,
           memo != viewModel.memo {
            viewModel.memo = memo
            delegate?.didEndEditingMemo(viewModel: viewModel)
        }
        memoTextField.resignFirstResponder()
        dismiss(animated: true)
    }
    
    @objc func handleReminderCellTap() {
        print("reminder tapped")
        // show reminder setting
    }
    
    @objc func handleDoTodayCellTap() {
        print("do today tapped")
        // set date to today
        dismiss(animated: true)
    }
    
    @objc func handleDoTomorrowCellTap() {
        print("do tomorrow tapped")
        // set date to tomorrow
        dismiss(animated: true)
    }
    
    @objc func handleChangeDateCellTap() {
        // show calendar
        print("change date tapped")
    }
    
    @objc func handleMoveToArchiveCellTap() {
        print("move to archive tapped")
        // remove date
        dismiss(animated: true)
    }
}

extension TodoDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin")
        memoCell.showDoneBtn()
    }
}
