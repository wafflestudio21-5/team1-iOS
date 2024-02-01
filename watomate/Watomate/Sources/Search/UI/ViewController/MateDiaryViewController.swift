//
//  MateDiaryViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/27/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Combine
import SnapKit
import UIKit

protocol MateDiaryViewControllerDelegate: AnyObject {
    func likedWithEmoji(diaryId: Int, user: Int, emoji: String)
    func updateComments(diaryId: Int, comments: [CommentCellViewModel])
//    func updateComments(comments: [CommentCellViewModel])
}

class MateDiaryViewController: DraggableCustomBarViewController {
    var delegate: MateDiaryViewControllerDelegate?
    private let viewModel: MateDiaryViewModel
    private var commentListDataSource: UITableViewDiffableDataSource<CommentSection, CommentCellViewModel.ID>!
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isScrollNeeded = false
    private var inputTextViewHeight: CGFloat = 41
    
    init(_ viewModel: SearchDiaryCellViewModel) {
        self.viewModel = MateDiaryViewModel(diary: viewModel, searchUserCase: SearchUseCase(searchRepository: SearchRepository()))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCommentDataSource()
        setupNavigationBar()
        setupLayout()
        configure()
        setupColor()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentView.addGestureRecognizer(tap)
        viewModel.input.send(.viewDidLoad)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateComments(diaryId: viewModel.diaryId, comments: viewModel.comments)
    }
    
    private func configureCommentDataSource() {
        commentListDataSource = UITableViewDiffableDataSource(tableView: commentTableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell else { fatalError() }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.configure(with: viewModel.commentViewModel(at: indexPath))
            self.divisionView.isHidden = false 
            return cell
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
            output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let userId = User.shared.id else { return }
                guard let self else { return }
                switch event {
                case let .successSaveLike(emoji):
                    configure()
                    delegate?.likedWithEmoji(diaryId: self.viewModel.diaryId, user: userId, emoji: emoji)
                case let .showComments(comments):
                    showComments(comments: comments)
                case let .updateComments(comments):
                    isScrollNeeded = true
                    showComments(comments: comments)
                    hideKeyboard()
                }
            }.store(in: &cancellables)
        
        commentTableView.publisher(for: \.contentSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] me in
                guard let self else { return }
                self.commentTableView.snp.remakeConstraints { make in
                    make.top.equalTo(self.divisionView.snp.bottom)
                    make.trailing.leading.bottom.equalToSuperview()
                    make.height.equalTo(me.height + 20)
                    if self.isScrollNeeded {
                        let isNearBottom = self.diaryContainerView.contentOffset.y >= (self.diaryContainerView.contentSize.height - self.diaryContainerView.bounds.size.height - 100) // 100은 여백을 위한 임의의 값
                        if !isNearBottom {
                            let bottomOffset = CGPoint(x: 0, y: self.diaryContainerView.contentSize.height - self.diaryContainerView.bounds.size.height)
                            self.diaryContainerView.setContentOffset(bottomOffset, animated: true)
                        }
                        
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func showComments(comments: [CommentCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentCellViewModel.ID>()
        snapshot.appendSections(CommentSection.allCases)
        snapshot.appendItems(comments.map{ $0.id }, toSection: .main)
        self.commentListDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupColor() {
        setBackgroundColor(viewModel.color.uiColor)
        contentView.backgroundColor = viewModel.color.uiColor
        commentContainerView.backgroundColor = viewModel.color.uiColor
        shadowView.backgroundColor = viewModel.color.uiColor
        
        
        setTitleAndButtonColor(viewModel.color.label)
        moodLabel.textColor = viewModel.color.label
        usernameLabel.textColor = viewModel.color.label
        dateLabel.textColor = viewModel.color.label
        visibilityLabel.textColor = viewModel.color.label
        diaryContents.textColor = viewModel.color.label
        
    }
    
    @objc func hideKeyboard() {
        contentView.endEditing(true)
        inputTextView.snp.remakeConstraints { make in
            make.height.equalTo(41)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        bottomPadding.isHidden = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomPadding.isHidden = false
    }
    
    private func setupNavigationBar() {
        setTitle("일기")
        setLeftXButton()
    }
    
    private func setupLayout() {
        contentView.addSubview(statusStackView)
        contentView.addSubview(userInfoView)
        contentView.addSubview(diaryContainerView)
        contentView.addSubview(shadowView)
        contentView.addSubview(commentContainerView)
        
        statusStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5.adjustedH)
            make.leading.trailing.equalToSuperview()
        }
        
        userInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30.adjusted)
            make.top.equalTo(statusStackView.snp.bottom).offset(20.adjustedH).priority(999) // 나중에 고칠 수 있을까?
        }
        
        diaryContainerView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(30.adjusted)
        }
        
        shadowView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(diaryContainerView.snp.bottom)
            make.height.equalTo(13)
        }
        
        commentContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(shadowView.snp.bottom)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func configure() {
        emojiView.text = viewModel.emoji
        if let mood = viewModel.mood {
            moodLabel.text = "\(mood)°"
            moodBar.setProgress(Float(mood) / 100.0 , animated: false)
            moodStackView.isHidden = false
        }
        if let profilePic = viewModel.profilePic {
            profileCircleView.setImage(profilePic)
        } else {
            profileCircleView.setDefault()
        }
        usernameLabel.text = viewModel.username
        dateLabel.text = viewModel.date
        if let image = viewModel.image {
            diaryImage.isHidden = false
        }
        diaryContents.text = viewModel.description
        
        switch viewModel.visibility {
        case .PB:
            boxView.image = UIImage(named: "pb")
            visibilityLabel.text = "전체공개"
        case .PR:
            boxView.image = UIImage(named: "pr")
            visibilityLabel.text = "나만보기"
        case .FL:
            boxView.image = UIImage(named: "fl")
            visibilityLabel.text = "팔로워 공개"
        }
        
        footerView.configure(likes: viewModel.likes, color: viewModel.color, userId: User.shared.id!)
        
    }
    
    // status(emoji, mood) 스택 뷰
    private lazy var statusStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14.adjusted
        stackView.alignment = .center
        
        stackView.addArrangedSubview(emojiView)
        stackView.addArrangedSubview(moodStackView)
        return stackView
    }()
    
    private lazy var emojiView = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 47)
        return label
    }()
    
    private lazy var moodStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6.adjusted
        stackView.isHidden = true
        
        stackView.addArrangedSubview(moodBar)
        stackView.addArrangedSubview(moodLabel)
        return stackView
    }()
    
    private lazy var moodBar = {
        let bar = UIProgressView()
        bar.clipsToBounds = true
        bar.layer.cornerRadius = 4.adjusted
        bar.progressTintColor = UIColor(red: 236.0/255.0, green: 110.0/255.0, blue: 223.0/255.0, alpha: 1)
        bar.trackTintColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        
        bar.snp.makeConstraints { make in
            make.width.equalTo(50.adjusted)
            make.height.equalTo(9.adjusted)
        }
        return bar
    }()
    
    private lazy var moodLabel = {
        var label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.bold, size: 14.adjusted)
        return label
    }()
    
    // userInfo(프로필사진, 유저 이름, 날짜, 공개 설정) 뷰
    private lazy var userInfoView = {
        let view = UIView()
        profileCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.headerViewHeight)
        }
        
        view.addSubview(profileCircleView)
        profileCircleView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileCircleView)
            make.leading.equalTo(profileCircleView.snp.trailing).offset(Constants.SearchDiary.offset)
        }
        
        view.addSubview(boxView)
        boxView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5.adjusted)
            make.width.height.equalTo(25)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(visibilityLabel)
        visibilityLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(1.adjusted)
            make.leading.equalTo(boxView.snp.trailing).offset(2.adjusted)
            make.height.equalTo(25)
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2.adjusted
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(horizontalStackView)
        
        return stackView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.semiBold, size: 16.adjusted)
        return label
    }()
    
    private lazy var horizontalStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2.adjusted
        
        stackView.addArrangedSubview(dateLabel)
        
        return stackView
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.medium, size: 14.adjusted)
        return label
    }()
    
    private lazy var boxView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var visibilityLabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Font.regular, size: 14)
        label.textColor = .label
        return label
    }()
    
    private lazy var diaryContainerView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.addSubview(diaryStackView)
        diaryStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.leading.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        view.addSubview(divisionView)
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(diaryStackView.snp.bottom).offset(12.adjustedH)
            make.leading.trailing.equalToSuperview().inset(-10)
            make.height.equalTo(3)
        }
        
        view.addSubview(commentTableView)
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(divisionView.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(500)
        }
        
        return view
    }()
    
    private lazy var diaryStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 20.adjusted
        
        stackView.addArrangedSubview(diaryImage)
        stackView.addArrangedSubview(diaryContents)
        stackView.addArrangedSubview(footerView)
        stackView.addArrangedSubview(commentTableView)
        
        commentTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        return stackView
    }()
    
    private lazy var diaryImage = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var diaryContents = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var footerView = {
        let view = LikeContainerView(size: .regular)
        view.addLikeTapAction(target: self, action: #selector(likeTapped))
        return view
    }()
    
    @objc func likeTapped() {
        guard let userId = User.shared.id else { return }
        let vc = LikeEmojiViewController()
        vc.diaryId = viewModel.diaryId
        vc.userId = userId
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 280
            })]
        }
        present(vc, animated: true)
    }
    
    private lazy var shadowView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowOffset = CGSize(width: 0, height: -8)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.label.cgColor
        return view
    }()
    
    private lazy var divisionView = {
        let view = UIView()
        view.backgroundColor = Color.gray.uiColor.withAlphaComponent(0.5)
//        view.clipsToBounds = true
        view.isHidden = true
        view.layer.cornerRadius = 0.2
        return view
    }()
    
    private lazy var commentTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.showsVerticalScrollIndicator = false
//        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var commentContainerView = {
        let view = UIStackView()
        view.axis = .vertical
        
        view.addArrangedSubview(commentView)
        view.addArrangedSubview(bottomPadding)
        
        return view
    }()
    
    private lazy var commentView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .bottom
        view.spacing = 12
        
        view.addArrangedSubview(inputTextView)
        view.addArrangedSubview(sendButton)
        
//        view.addSubview(sendButton)
//        sendButton.snp.makeConstraints { make in
//            make.top.trailing.bottom.equalToSuperview()
//        }
//        
//        view.addSubview(inputTextView)
//        inputTextView.snp.makeConstraints { make in
//            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
//            make.top.bottom.leading.equalToSuperview()
//        }
        return view
    }()
    
    private lazy var inputTextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 22
        textView.isScrollEnabled = false
        textView.font = UIFont(name: Constants.Font.regular, size: 14)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
//        textView.textContainer.maximumNumberOfLines = 4
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textColor = .label
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        return textView
    }()
    
    private lazy var sendButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send_default"), for: .normal)
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        return button
    }()
    
    @objc private func sendTapped() {
        guard let comment = inputTextView.text else { return }
        viewModel.input.send(.commentSendTapped(comment: comment))
        inputTextView.text = nil
    }
    
    private lazy var bottomPadding = {
        let view = UIView()
        
        view.snp.makeConstraints { make in
            make.height.equalTo(50.adjustedH)
        }
        
        return view
    }()
    
}

extension MateDiaryViewController: LikeEmojiViewControllerDelegate {
    func likeWithEmoji(diaryId: Int, user: Int, emoji: String) {
        viewModel.saveLike(diaryId: diaryId, userId: user, emoji: emoji)
    }
    
}

extension MateDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: inputTextView.frame.width, height: .infinity)
       let estimatedSize = inputTextView.sizeThatFits(size)
        
        if inputTextViewHeight != estimatedSize.height {
            if estimatedSize.height <= 91 { // Define maximumHeight
                textView.isScrollEnabled = false
                inputTextView.snp.remakeConstraints { make in
                    make.height.equalTo(estimatedSize)
                    make.trailing.equalTo(sendButton.snp.leading).offset(-12)
                    make.leading.equalToSuperview()
                }
                view.layoutIfNeeded()
            } else {
                textView.isScrollEnabled = true
            }
        }

    }
}

extension MateDiaryViewController: CommentCellDelegate {
    func editComment(commentId: Int, comment: String) {
        viewModel.input.send(.editComment(commentId: commentId, comment: comment))
    }
    
    func deleteComment(commentId: Int) {
        showAlert(message: "댓글을 삭제하시겠습니까?") { [weak self] _ in
            self?.viewModel.input.send(.deleteComment(commentId: commentId))
        }
    }
    
    private func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
        present(alert, animated: true)
    }
    
    
}
