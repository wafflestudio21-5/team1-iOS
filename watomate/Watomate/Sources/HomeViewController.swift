//
//  HomeViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class HomeViewController: TodoTableViewController {
    var diaryViewModel = DiaryPreviewViewModel()
    var homeViewModel = HomeViewModel()
    lazy var userID = User.shared.id
    var selectedDate: DateComponents? = nil
    
    private lazy var logoImage : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(systemName: "gearshape") // 추후 최종 로고 이미지로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var notificationButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "bell"))
        // button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var showmoreButton : UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .action)
        // button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var followingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .gray
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupTopBarItems()
    }
    
    override func viewDidLoad() {
        todoTableView.register(CalendarHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarHeaderView.reuseIdentifier)
        super.viewDidLoad()
        guard let userID else { return }
        getHomeUser(userID: userID)
//        setCalendar()
    }
    override func setupLayout() {
        //TODO: add following/follower info, tedoori
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        view.addSubview(followingStackView)
        followingStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        view.addSubview(todoTableView)
        todoTableView.snp.makeConstraints { make in
            make.top.equalTo(followingStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTopBarItems() {
        self.navigationItem.rightBarButtonItems = [showmoreButton, notificationButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImage)
    }
    
    func getHomeUser(userID: Int) {
        homeViewModel.getHomeUser(userID: userID) {
            DispatchQueue.main.async { [weak self] in
//                self?.updateUserInfo()
                self?.updateUserTedoori()
            }
        }
    }

    private func updateUserTedoori(){
        if homeViewModel.user?.tedoori == true{
//            profileImageContainer.layer.borderWidth =  TedooriConstants.outerBorderWidth
//            profileImageContainer.layer.borderColor = TedooriConstants.outerBorderColor.cgColor
//            profileImage.layer.borderWidth = TedooriConstants.innerBorderWidth
//            profileImage.layer.borderColor = TedooriConstants.innerBorderColor.cgColor
        }
        else{
//            profileImageContainer.layer.borderWidth =  0
//            profileImage.layer.borderWidth = 0
        }
    } // todo 상태 바뀔 때마다 updateusertedoori 불러와야 함

    private var diaryDateString: String = {
        return Utils.YYYYMMddFormatter().string(from: Date())
    }()
    
    var emoji = "no emoji"
    @objc func diaryButtonTapped() {
        if emoji == "no emoji" {
             let diaryCreateVC = DiaryCreateViewController()
             diaryCreateVC.receivedDateString = diaryDateString
             diaryCreateVC.existence = false
             diaryCreateVC.completionClosure = { receivedValue in
                 self.emoji = receivedValue
                 self.updateDiaryButtonAppearance()
             }
            diaryCreateVC.userName = homeViewModel.user?.username
            diaryCreateVC.userProfile = homeViewModel.user?.profile_pic
            diaryCreateVC.hidesBottomBarWhenPushed = true //tabBar 숨기기
            navigationController?.pushViewController(diaryCreateVC, animated: false)
        }
        else{
            let diaryPreviewVC = DiaryPreviewViewController()
            diaryPreviewVC.receivedDateString = diaryDateString
            diaryPreviewVC.userName = homeViewModel.user?.username
            diaryPreviewVC.userProfile = homeViewModel.user?.profile_pic
            setSheetLayout(for: diaryPreviewVC)
            diaryPreviewVC.delegate = self
            present(diaryPreviewVC, animated: true, completion: nil)
        }
   }
    
    private func updateDiaryButtonAppearance() {
        let headerView = tableView(todoTableView, viewForHeaderInSection: 0) as! CalendarHeaderView
        let diaryButton = headerView.diaryButton
        if emoji == "no emoji" {
            diaryButton.setTitle(nil, for: .normal)
            diaryButton.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        } else {
            diaryButton.setImage(nil, for: .normal)
            diaryButton.setTitle(emoji, for: .normal)
        }
    }
    
    

    
    private func reloadCalendarView(date: Date?) {
       if date == nil { return }
       let calendar = Calendar.current
//       calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
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

extension HomeViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarHeaderView.reuseIdentifier) as? CalendarHeaderView else { return nil }
            header.contentView.backgroundColor = .systemBackground
            header.setDiaryBtnAction(target: self, action: #selector(diaryButtonTapped), for: .touchUpInside)
            return header
        }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoHeaderView.reuseIdentifier) as? TodoHeaderView else { return nil }
        header.goalView.tag = section
        header.setTitle(with: todoListViewModel.getTitle(of: section))
        header.setColor(with: todoListViewModel.getColor(of: section))
        header.setVisibility(with: todoListViewModel.getVisibility(of: section))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addEmptyTodo))
        header.goalView.addGestureRecognizer(tapGesture)
        header.goalView.isUserInteractionEnabled = true
        header.contentView.backgroundColor = .systemBackground
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 400
        }
        return 60
    }
}






extension HomeViewController: DiaryPreviewViewControllerDelegate {
    func diaryPreviewViewControllerDidRequestDiaryCreation(_ controller: DiaryPreviewViewController) {
        controller.dismiss(animated: true) {
            let diaryCreateVC = DiaryCreateViewController()
            diaryCreateVC.receivedDateString = self.diaryDateString
            diaryCreateVC.userName = self.homeViewModel.user?.username
            diaryCreateVC.userProfile = self.homeViewModel.user?.profile_pic
            diaryCreateVC.existence = true
            diaryCreateVC.completionClosure = { receivedValue in
                self.emoji = receivedValue
                self.updateDiaryButtonAppearance()
            }
            diaryCreateVC.hidesBottomBarWhenPushed = true //tabBar 숨기기
            self.navigationController?.pushViewController(diaryCreateVC, animated: false)
        }
    }
}
