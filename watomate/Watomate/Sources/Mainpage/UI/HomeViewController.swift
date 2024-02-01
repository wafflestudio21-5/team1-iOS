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
        updateUserTedoori()
        getHomeUser(userID: userID)
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
            make.top.equalTo(followingStackView.snp.bottom)
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
        // calendar초기선택값 지정해야함 -> 안하면 dateString못가져와서 투두 추가 불가능
        guard let date = selectedDate?.date else { return }
        let dateString = Utils.YYYYMMddFormatter().string(from: date)
        let success = todoListViewModel.appendPlaceholderIfNeeded(at: section, with: dateString)//with date
        if !success {
            todoTableView.endEditing(false)
        }
    }
}

extension HomeViewController: TodoListViewModelDelegate {
    
    func todoListViewModel(_ viewModel: TodoListViewModel, didInsertCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath) {
        Task { @MainActor in
            if let cell = todoTableView.cellForRow(at: indexPath) as? TodoCell {
                cell.titleBecomeFirstResponder()
                todoTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
    //        updateUnavailableView()
        }
    }

    func todoListViewModel(_ viewModel: TodoListViewModel, didRemoveCellViewModel todoViewModel: TodoCellViewModel, at indexPath: IndexPath, options: ReloadOptions) {
        if options.contains(.reload) {
            let animated = options.contains(.animated)
            todoTableView.deleteRows(at: [indexPath], with: animated ? .automatic : .none)
        }
//        updateUnavailableView()
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            diaryDateString = dateFormatter.string(from: selectedDate)
            guard let userID else { return }
            getDiary(userID: userID, date: diaryDateString)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            diaryDateString = dateFormatter.string(from: Date())
            guard let userID else { return }
            getDiary(userID: userID, date: diaryDateString)
        }
        if let date = selectedDate?.date {
            let dateString = Utils.YYYYMMddFormatter().string(from: date)
            todoListViewModel.loadTodos(on: dateString)
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
