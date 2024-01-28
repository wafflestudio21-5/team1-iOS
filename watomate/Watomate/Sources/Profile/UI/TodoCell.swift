//
//  TodoCell.swift
//  Watomate
//
//  Created by 권현구 on 1/9/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    static let reuseIdentifier = "TodoCell"
    var viewModel: TodoCellViewModel?

    private lazy var checkbox = {
        let view = CustomSymbolView(size: 25)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var titleStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showBottomSheetView))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private lazy var textStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()

    private lazy var titleTextField = {
        let textField = UITextField()
        textField.allowsEditingTextAttributes = false
        textField.isUserInteractionEnabled = false
        textField.textColor = .label
        textField.placeholder = "할 일 입력"
        textField.font = .systemFont(ofSize: 16)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.delegate = self
        return textField
    }()
    
    private lazy var threeDotImage = {
        let image = UIImage(systemName: "ellipsis")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var memoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var memoImage = {
        let image = UIImage(systemName: "note.text")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var memoLabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        observeTextChanges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(25)
        }

        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(checkbox.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(16)
        }

        titleStackView.addArrangedSubview(titleTextField)
        titleStackView.addArrangedSubview(threeDotImage)
        memoStackView.addArrangedSubview(memoImage)
        memoStackView.addArrangedSubview(memoLabel)
        textStackView.addArrangedSubview(titleStackView)
        textStackView.addArrangedSubview(memoStackView)
    }

    func titleBecomeFirstResponder() {
        titleTextField.allowsEditingTextAttributes = true
        titleTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
    }

    private func observeTextChanges() {
        titleTextField.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingChanged)
    }

    @objc private func titleDidChange(_ textField: UITextField) {
        viewModel?.title = textField.text ?? ""
    }

    func configure(with viewModel: TodoCellViewModel) {
        self.viewModel = viewModel
        titleTextField.text = viewModel.title
        titleTextField.allowsEditingTextAttributes = false
        memoStackView.isHidden = viewModel.isMemoHidden
        configureCheckbox(isComplete: viewModel.isCompleted)
    }

    private func toggleMemoTextFieldVisibility(_ isHidden: Bool) {
        if isHidden,
           let memo = viewModel?.memo,
           !memo.isEmpty {
            setMemoLabelIsHidden(false)
            return
        }
        
        setMemoLabelIsHidden(true)
    }

    private func setMemoLabelIsHidden(_ value: Bool) {
        memoStackView.isHidden = value
        UIView.performWithoutAnimation {
            invalidateIntrinsicContentSize()
        }
    }

    @objc private func showBottomSheetView() {
        viewModel?.navigateToDetail()
    }
    
    @objc private func toggleCheckbox() {
        viewModel?.isCompleted.toggle()
        let isComplete = viewModel?.isCompleted == true
        configureCheckbox(isComplete: isComplete)
        // notify todo isCompleted is changed
    }

    private func configureCheckbox(isComplete: Bool) {
        if isComplete {
            checkbox.addCheckMark()
            checkbox.setColor(color: [.green])// TODO: change to Goal.color
        } else {
            checkbox.removeCheckMark()
            checkbox.setColor(color: [])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension TodoCell: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        //add bar under the textField
//        guard let viewModel else { return }
//        
//        print("did begin editing")
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.endEditingTitle(with: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == titleTextField else { return true }
        if textField.text?.isEmpty == false {
            textField.allowsEditingTextAttributes = false
            textField.isUserInteractionEnabled = false
            viewModel?.addNewTodoItem()
            return false
        } else {
            textField.resignFirstResponder()
            return false
        }
    }
}
