//
//  CalendarHeaderView.swift
//  Watomate
//
//  Created by 권현구 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class CalendarHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "CalendarHeaderView"
    
    var emoji = "no emoji"

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        profileImageContainer.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
    }
    
    private lazy var statusView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.addArrangedSubview(profileImageContainer)
        stackView.addArrangedSubview(profileLabelStackView)
        stackView.addArrangedSubview(diaryButton)
        return stackView
    }()
    
    private lazy var profileImageContainer: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "gearshape"))
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = ProfileImageConstant.thumbnailSize / 2.0
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var profileLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(profileName)
        stackView.addArrangedSubview(profileIntro)
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.text = "test username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileIntro: UILabel = {
        var label = UILabel()
        label.text = "프로필에 자기소개를 입력해보세요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var diaryButton : UIButton = {
        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(diaryButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var headerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(calendarView)
        return stackView
    }()
    
    private lazy var calendarView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    func setDiaryBtnAction(target: Any?, action: Selector, for event: UIControl.Event) {
        diaryButton.addTarget(target, action: action, for: event)
    }
    
    func updateUserInfo(with homeViewModel: HomeViewModel){
        // let profileImageUrl = URL(string: homeViewModel.user?.profile_pic)
        // profileImage.kf.setImage(with: profileImageUrl)
        // kingfisher no such module error
        profileName.text = homeViewModel.user?.username
        profileIntro.text = homeViewModel.user?.intro
        
        // followingProfileName.text = "following user name"
        // followingProfileImage.image = UIImage(named: "waffle.jpg")
    }
    
    fileprivate func setCalendar() {
//        calendarView.delegate = self
//
//        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
//        calendarView.selectionBehavior = dateSelection
        calendarView.fontDesign = .rounded
    }
}
