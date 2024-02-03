//
//  HomeViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class HomeViewController: TodoTableViewController {
    let diaryViewModel: DiaryPreviewViewModel
    var homeViewModel = HomeViewModel()
    lazy var userID = User.shared.id
    var selectedDate: DateComponents? = nil
    
    init(todoListViewModel: TodoListViewModel, diaryViewModel: DiaryPreviewViewModel) {
        self.diaryViewModel = diaryViewModel
        super.init(todoListViewModel: todoListViewModel)
        self.todoListViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logoImage : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "logo") // 추후 최종 로고 이미지로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var notificationButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "bell"))
        // button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func showmoreButtonTapped() {
        let goalManageVC = GoalManageViewController()
        navigationController?.pushViewController(goalManageVC, animated: false)
   }
    
    private lazy var showmoreButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(showmoreButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    
    private lazy var followingView = FollowingView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupTopBarItems()
        followingView.refreshData()
    }
    
    override func viewDidLoad() {
        todoTableView.register(CalendarHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarHeaderView.reuseIdentifier)
        super.viewDidLoad()
        guard let userID else { return }
        updateUserTedoori()
        getHomeUser(userID: userID)
        followingView.onTap = { [weak self] in
            let followingVC = FollowingViewController()
            self?.navigationController?.pushViewController(followingVC, animated: true)
        }
        
    }
    
    override func setupLayout() {
        //TODO: add following/follower info, tedoori
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        

        view.addSubview(followingView)
        followingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(80)
        }
        
        view.addSubview(todoTableView)
        todoTableView.snp.makeConstraints { make in
            make.top.equalTo(followingView.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTopBarItems() {
        self.navigationItem.rightBarButtonItems = [showmoreButton, notificationButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImage)
    }
    
    func getHomeUser(userID: Int) {
        homeViewModel.getHomeUser(userID: userID) {
            Task {@MainActor [weak self] in
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
            diaryCreateVC.setupProfile()
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
        let headerView = tableView(todoTableView, viewForHeaderInSection: 0) as! CalendarHeaderView
        let calendarView = headerView.calendarView
        calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    private func getStringToDate(strDate: String) -> Date {
        let dateFormatter = Utils.YYYYMMddFormatter()
        return dateFormatter.date(from: strDate)!
    } //UICalendar은 date형 데이터 사용 : string -> date 형변환 함수
    
    private func getDateString(from dateComponent: DateComponents?) -> String? {
        guard let dateComponent else { return nil }
        let dateFormatter = Utils.YYYYMMddFormatter()
        guard let date = dateComponent.date else { return nil }
        return dateFormatter.string(from: date)
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarHeaderView.reuseIdentifier) as? CalendarHeaderView else { return nil }
            header.contentView.backgroundColor = .systemBackground
            header.setDiaryBtnAction(target: self, action: #selector(diaryButtonTapped), for: .touchUpInside)
            header.setupUserInfo()
            header.calendarView.delegate = self
            let dateSelection = UICalendarSelectionSingleDate(delegate: self)
            header.calendarView.selectionBehavior = dateSelection
            header.calendarView.fontDesign = .rounded
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
    
    override func addEmptyTodo(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? GoalStackView else { return }
        let section = headerView.tag
        let date = selectedDate?.date ?? Utils.getDateOfToday()
        let dateString = Utils.YYYYMMddFormatter().string(from: date)
        let success = todoListViewModel.appendPlaceholderIfNeeded(at: section, with: dateString)
        if !success {
            todoTableView.endEditing(false)
        }
    }
}

extension HomeViewController: TodoListViewModelDelegate {
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didInsertCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        Task { @MainActor in
            if let cell = todoTableView.cellForRow(at: indexPath) as? TodoCell {
                todoTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                cell.titleBecomeFirstResponder()
            }
        }
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, showDetailViewWith cellViewModel: TodoCellViewModel) {
        let vc = TodoDetailViewController(viewModel: cellViewModel)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didChangeDateOf cellViewModel: TodoCellViewModel) {
        guard let date = selectedDate?.date else {
            input.send(.viewDidAppear(self))
            return
        }
        let dateString = Utils.YYYYMMddFormatter().string(from: date)
        if dateString != cellViewModel.date {
            todoListViewModel.loadTodos(on: dateString)
        }
        Task { @MainActor in
            reloadCalendarView(date: Utils.YYYYMMddFormatter().date(from: dateString))
        }
    }
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didUpdateViewModel cellViewModel: TodoCellViewModel) {
//        guard let dateString = cellViewModel.date else { return }
//        Task { @MainActor in
//            todoTableView.reloadData()
//        }
    }
}

extension HomeViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
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
            let dateFormatter = Utils.YYYYMMddFormatter()
            diaryDateString = dateFormatter.string(from: selectedDate)
            guard let userID else { return }
            getDiary(userID: userID, date: diaryDateString)
        } else {
            let dateFormatter = Utils.YYYYMMddFormatter()
            diaryDateString = dateFormatter.string(from: Date())
            guard let userID else { return }
            getDiary(userID: userID, date: diaryDateString)
        }
        if let date = selectedDate?.date {
            let dateString = Utils.YYYYMMddFormatter().string(from: date)
            todoListViewModel.loadTodos(on: dateString)
        }
        Task { @MainActor in
            reloadCalendarView(date: Calendar.current.date(from: dateComponents!))
        }
    }
    
    // 캘린더에 todo 띄우기
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let targetDateStr = getDateString(from: dateComponents) else { return nil }
        let selectedDateStr = getDateString(from: selectedDate)
        if targetDateStr == selectedDateStr {
            // 서버 연동 후 날짜별로 맞는 emoji 가져오기
        }
        return .customView {
            let view = UIView()
            let customView = CustomSymbolView(size: 15)
            view.addSubview(customView)
            customView.snp.makeConstraints { make in
                make.height.width.equalTo(15)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
            }
            if let dateTodosInfo = self.todoListViewModel.getTodosInfo(on: targetDateStr) {
                if dateTodosInfo.0 == 0 {
                    customView.setColor(color: dateTodosInfo.1)
                    customView.addCheckMark()
                } else {
                    customView.addNumber(numberString: "\(dateTodosInfo.0)")
                }
            }
            return view
        }
    }
}

extension HomeViewController: DiaryPreviewViewControllerDelegate {
    func diaryPreviewViewControllerDidRequestDiaryCreation(_ controller: DiaryPreviewViewController) {
        controller.dismiss(animated: true) {
            let diaryCreateVC = DiaryCreateViewController()
            diaryCreateVC.receivedDateString = self.diaryDateString
            diaryCreateVC.setupProfile()
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
