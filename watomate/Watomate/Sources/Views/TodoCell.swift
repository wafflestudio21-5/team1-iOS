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
        let image = UIImage(systemName: "circle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
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

    private lazy var titleLabel = {
        let titleLabel = UITextField()
        titleLabel.allowsEditingTextAttributes = false
        titleLabel.isUserInteractionEnabled = false
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return titleLabel
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

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(threeDotImage)
        memoStackView.addArrangedSubview(memoImage)
        memoStackView.addArrangedSubview(memoLabel)
        textStackView.addArrangedSubview(titleStackView)
        textStackView.addArrangedSubview(memoStackView)
    }

    func titleBecomeFirstResponder() {
        titleLabel.becomeFirstResponder()
    }

    private func observeTextChanges() {
//        titleLabel.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingChanged)
//        memoTextField.addTarget(self, action: #selector(memoDidChange(_:)), for: .editingChanged)
    }

    @objc private func titleDidChange(_ textField: UITextField) {
        viewModel?.title = textField.text ?? ""
    }

    @objc private func memoDidChange(_ textField: UITextField) {
        viewModel?.memo = textField.text
    }

    func configure(with viewModel: TodoCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        titleLabel.allowsEditingTextAttributes = false
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
        // navigate to bottom sheet view with viewModel
        print("show bottom sheet view")
    }
    
    @objc private func toggleCheckbox() {
        viewModel?.isCompleted.toggle()
        let isComplete = viewModel?.isCompleted == true
        configureCheckbox(isComplete: isComplete)
        // notify todo isCompleted is changed
    }

    private func configureCheckbox(isComplete: Bool) {
        checkbox.image = UIImage(systemName: isComplete ? "circle.inset.filled" : "circle")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
