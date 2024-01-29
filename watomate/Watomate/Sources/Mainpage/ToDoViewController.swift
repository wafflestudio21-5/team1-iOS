//
//  ToDoViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2023/12/31.
//

import UIKit
import SnapKit
// import KingFisher

class ToDoViewController: UIViewController {
    var diaryViewModel = DiaryPreviewViewModel()
    var homeViewModel = HomeViewModel()
    var userID = 3 //로그인이랑 연동해서 수정!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        getHomeUser(userID: userID)
        setCalendar()
        //setupInnerBorder()
    }
    
    func getHomeUser(userID: Int) {
        homeViewModel.getHomeUser(userID: userID) {
            DispatchQueue.main.async { [weak self] in
                self?.updateUserInfo()
            }
        }
    }
    
    private func updateUserInfo(){
        // let profileImageUrl = URL(string: homeViewModel.user?.profile_pic)
        // profileImage.kf.setImage(with: profileImageUrl)
        // kingfisher no such module error
        profileName.text = homeViewModel.user?.username
        profileIntro.text = homeViewModel.user?.intro
        updateUserTedoori()
        // followingProfileName.text = "following user name"
        // followingProfileImage.image = UIImage(named: "waffle.jpg")
    }
    
    private func updateUserTedoori(){
        if homeViewModel.user?.tedoori == true{
            profileImageContainer.layer.borderWidth =  TedooriConstants.outerBorderWidth
            profileImageContainer.layer.borderColor = TedooriConstants.outerBorderColor.cgColor
            profileImage.layer.borderWidth = TedooriConstants.innerBorderWidth
            profileImage.layer.borderColor = TedooriConstants.innerBorderColor.cgColor
        }
        else{
            profileImageContainer.layer.borderWidth =  0
            profileImage.layer.borderWidth = 0
        }
    } // todo 상태 바뀔 때마다 updateusertedoori 불러와야 함
    
    
    private var diaryDateString: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }()
    
    var emoji = "no emoji"
    @objc func diaryButtonTapped() {
        if emoji == "no emoji" {
            let diaryViewController = DiaryCreateViewController()
             diaryViewController.receivedDateString = diaryDateString
             diaryViewController.completionClosure = { receivedValue in
                 self.emoji = receivedValue
                 self.updateDiaryButtonAppearance()
             }
            diaryViewController.hidesBottomBarWhenPushed = true //tabBar 숨기기
            navigationController?.pushViewController(diaryViewController, animated: false)
        }
        else{
            let vc = DiaryPreviewViewController()
            vc.receivedDateString = diaryDateString
            setSheetLayout(for: vc)
            present(vc, animated: true, completion: nil)
        }
   }
    
    private func updateDiaryButtonAppearance() {
        if emoji == "no emoji" {
            diaryButton.setTitle(nil, for: .normal)
            diaryButton.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        } else {
            diaryButton.setImage(nil, for: .normal)
            diaryButton.setTitle(emoji, for: .normal)
        }
    }

    private func setupLayout(){
        view.addSubview(header)
        view.addSubview(body)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.12)
         }
        body.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(8)
         }
    }
    
    private lazy var header: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        view.addSubview(followingView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
         }
        followingView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
         }
        return view
    }()
    
    private lazy var logoImage : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "wafflelogo.png") // 추후 최종 로고 이미지로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var notificationButton : UIButton = {
        let button = UIButton(type: .system)
        // button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var showmoreButton : UIButton = {
        let button = UIButton(type: .system)
        // button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleView : UIView = {
        var view = UIView()
        view.addSubview(logoImage)
        view.addSubview(notificationButton)
        view.addSubview(showmoreButton)
        logoImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(16)
         }
        notificationButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
           // make.leading.equalTo(logoImage.snp.trailing).offset(16)
            make.trailing.equalTo(showmoreButton.snp.leading).inset(-16)
         }
        showmoreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
         }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var followingView : UIView = {
        var view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(followingProfile)
        followingProfile.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().offset(8)
            make.width.equalTo(view.snp.height)
        }
        view.addSubview(moreFollowingImage)
        moreFollowingImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(8)
            make.leading.equalTo(followingProfile.snp.trailing)
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
            make.width.equalTo(view.snp.height).multipliedBy(0.6)
        }
        return view
    }()
    
    
    private lazy var followingProfile : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(followingProfileImage)
        followingProfileImage.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
            make.width.equalTo(view.snp.height).multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
        view.addSubview(followingProfileName)
        followingProfileName.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(followingProfileImage.snp.bottom).offset(4)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
            make.width.equalTo(view.snp.height).multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
    private lazy var followingProfileImage : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var followingProfileName : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
    private lazy var moreFollowingImage : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "morefollowing.jpg") // 추후 최종 로고 이미지로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statusView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageContainer)
        view.addSubview(profileName)
        view.addSubview(profileIntro)
        view.addSubview(diaryButton)
        profileImageContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview() //추후 프로필 이미지 사이즈에 따라 변형
            make.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(ProfileImageConstant.thumbnailSize)
         }
        
        profileName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
         }
        profileIntro.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom)
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
         }
        diaryButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
         }
        return view
    }()
    
    private lazy var profileImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = ProfileImageConstant.thumbnailSize / 2.0
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(TedooriConstants.innerBorderWidth)
        }
        return view
    }()

    
    private lazy var profileImage : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = (ProfileImageConstant.thumbnailSize - ProfileImageConstant.spacing) / 2.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileIntro: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var diaryButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(diaryButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var body: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        view.addSubview(calendarView)
        view.addSubview(todoView)
        statusView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.08)
         }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview()
           // make.height.equalTo(450)
            
         }
        todoView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
         }
        return view
    }()
    
    private lazy var calendarView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
      /* view.contentMode = .scaleAspectFit
        //uicalendarview의 defaultheight이 크다..
        //UICalendarView's height is smaller than it can render its content in; defaulting to the minimum height.
       */
        
        return view
    }()
    
    var selectedDate: DateComponents? = nil
    
    fileprivate func setCalendar() {
        calendarView.delegate = self

        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.fontDesign = .rounded
    }
    
    private func reloadCalendarView(date: Date?) {
       if date == nil { return }
       let calendar = Calendar.current
       calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    private func getStringToDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "Ko_KR") as TimeZone?
        
        return dateFormatter.date(from: strDate)!
    } //UICalendar은 date형 데이터 사용 : string -> date 형변환 함수
    
    
    let dummy_day = "2024-01-13"
    private lazy var dummy_days = [getStringToDate(strDate: dummy_day) : [1, "green"]] // [남은 일의 수, 목표 색]
    
    private lazy var todoView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
}


extension ToDoViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func getDiary(userID: Int, date: String) {
        emoji = "no emoji"
        updateDiaryButtonAppearance()
        diaryViewModel.getDiary(userID: userID, date: date) {
            DispatchQueue.main.async { [weak self] in
                if let emoji = self?.diaryViewModel.diary?.emoji {
                    self?.emoji = emoji
                    self?.updateDiaryButtonAppearance()
                }
            }
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        if let selectedDate = dateComponents?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            diaryDateString = dateFormatter.string(from: selectedDate)
            getDiary(userID: userID, date: diaryDateString)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            diaryDateString = dateFormatter.string(from: Date())
            getDiary(userID: userID, date: diaryDateString)
        }
        reloadCalendarView(date: Calendar.current.date(from: dateComponents!))
        
    }
    
    // 캘린더에 todo 띄우기
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let date = dateComponents.date!
        if dateComponents == selectedDate {
            // 서버 연동 후 날짜별로 맞는 emoji 가져오기
            return nil
        } else {
            if dummy_days.keys.contains(date),
               let data = dummy_days[date],
               let numericValue = data.first as? Int,
               let colorString = data.last as? String {
                return .customView {
                    let systemName = "\(numericValue).circle"
                    let imageView = UIImageView(image: UIImage(systemName: systemName))
                    imageView.tintColor = UIColor(named: colorString)
                    return imageView
                }
            } else {
                return nil
            }
        }
        
    }
    
}

