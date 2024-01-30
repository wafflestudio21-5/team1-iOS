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
}

class MateDiaryViewController: DraggableCustomBarViewController {
    var delegate: MateDiaryViewControllerDelegate?
    private let viewModel: MateDiaryViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ viewModel: SearchDiaryCellViewModel) {
        self.viewModel = MateDiaryViewModel(diaryCellViewModel: viewModel, searchUserCase: SearchUseCase(searchRepository: SearchRepository()))
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
        
        setupNavigationBar()
        setupLayout()
        configure()
        setupColor()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentView.addGestureRecognizer(tap)
        
    }
    
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] emoji in
            guard let userId = User.shared.id else { return }
            guard let self else { return }
            self.configure()
            self.likeCircleView.setSymbolColor(UIColor(red: 253.0/255.0, green: 93.0/255.0, blue: 93.0/255.0, alpha: 1))
            self.delegate?.likedWithEmoji(diaryId: self.viewModel.diaryId, user: userId, emoji: emoji)
        }.store(in: &cancellables)
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
        
        likeCircleView.setBackgroundColor(viewModel.color.heartBackground)
        if viewModel.isLiked {
            likeCircleView.setSymbolColor(UIColor(red: 253.0/255.0, green: 93.0/255.0, blue: 93.0/255.0, alpha: 1))
        } else {
            likeCircleView.setSymbolColor(viewModel.color.heartSymbol)
        }
    }
    
    @objc func hideKeyboard() {
        contentView.endEditing(true)
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
            make.top.equalTo(userInfoView.snp.bottom).offset(25.adjusted)
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
    
    @MainActor
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
        
        let likeCount = viewModel.likes.count
        switch likeCount {
        case 0:
            break
        case 1:
            emojiLabel1.isHidden = false
            emojiLabel1.text = viewModel.likes[0].emoji
            emojiCountLabel.isHidden = false
            emojiCountLabel.text = "1"
        default:
            emojiLabel1.isHidden = false
            emojiLabel1.text = viewModel.likes[likeCount - 1].emoji
            emojiLabel2.isHidden = false
            emojiLabel2.text = viewModel.likes[likeCount - 2].emoji
            emojiCountLabel.isHidden = false
            emojiCountLabel.text = String(likeCount)
        }
        
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
        label.font = UIFont.systemFont(ofSize: 50)
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
        
        view.addSubview(diaryStackView)
        diaryStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        return view
    }()
    
    private lazy var diaryStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 8.adjusted
        
        stackView.addArrangedSubview(diaryImage)
        stackView.addArrangedSubview(diaryContents)
        stackView.addArrangedSubview(footerView)
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
        let view = UIView()
        emojiContainerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.SearchDiary.footerViewHeight)
        }
        
        likeCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.footerViewHeight)
        }
        
        view.addSubview(emojiContainerView)
        emojiContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.adjustedH)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        view.addSubview(likeCircleView)
        likeCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var emojiContainerView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5.adjusted
        
        view.addArrangedSubview(emojiLabel1)
        view.addArrangedSubview(emojiLabel2)
        view.addArrangedSubview(emojiCountLabel)
        return view
    }()
    
    private lazy var emojiLabel1 = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var emojiLabel2 = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var emojiCountLabel = {
        let label = UILabel()
        label.textColor = .label
        label.isHidden = true
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var likeCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "heart.fill"))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTapped)))
        view.isUserInteractionEnabled = true
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
    
    private lazy var commentContainerView = {
        let view = UIStackView()
        view.axis = .vertical
        
        view.addArrangedSubview(commentView)
        view.addArrangedSubview(bottomPadding)
        
        return view
    }()
    
    private lazy var commentView = {
        let view = UIView()
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            make.top.bottom.leading.equalToSuperview()
        }
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
        textView.textContainer.maximumNumberOfLines = 4
        textView.textContainer.lineBreakMode = .byTruncatingHead
        textView.textColor = .label
        return textView
    }()
    
    private lazy var sendButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send_default"), for: .normal)
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        return button
    }()
    
    private lazy var bottomPadding = {
        let view = UIView()
        
        view.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        return view
    }()
    
}

extension MateDiaryViewController: LikeEmojiViewControllerDelegate {
    func likeWithEmoji(diaryId: Int, user: Int, emoji: String) {
        viewModel.saveLike(diaryId: diaryId, userId: user, emoji: emoji)
    }
    
    
}
