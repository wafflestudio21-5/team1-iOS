//
//  ToDoViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2023/12/31.
//

import UIKit
import SnapKit

class ToDoViewController: UIViewController {
    
    private var dateString: String?
    
    var emoji = "?"
    
    @objc func diaryButtonTapped() {
        if emoji == "?" {
            let diaryViewController = DiaryCreateViewController()
             diaryViewController.receivedDateString = dateString
             diaryViewController.completionClosure = { receivedValue in
                 self.emoji = receivedValue
                 self.updateDiaryButtonAppearance()
             }
            navigationController?.pushViewController(diaryViewController, animated: false)
        }
        else{
            let diaryViewController = DiaryPreviewViewController()
            
            navigationController?.pushViewController(diaryViewController, animated: false)
        }
       
   }
    
    private func updateDiaryButtonAppearance() {
        if emoji == "?" {
            diaryButton.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        } else {
            diaryButton.setImage(nil, for: .normal)
            diaryButton.setTitle(emoji, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setCalendar()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupLayout(){
        view.addSubview(header)
        view.addSubview(body)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.15)
            make.bottom.equalTo(body.snp.top)
         }
        body.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
        view.image = UIImage(named: "waffle.png") // 추후 최종 로고 이미지로 변경
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
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
         }
        notificationButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
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
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //
    
    private lazy var body: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        view.addSubview(calendarView)
        view.addSubview(todoView)
        statusView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
         }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).inset(30)
            make.leading.trailing.equalToSuperview()
           // make.height.equalTo(450)
            
         }
        todoView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
         }
        return view
    }()
    
    private lazy var statusView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        view.addSubview(profileName)
        view.addSubview(diaryButton)
        profileImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(22) //추후 프로필 이미지 사이즈에 따라 변형
            make.leading.equalToSuperview().inset(8)
         }
        profileName.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).inset(-8)
         }
        diaryButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
         }
        return view
    }()
    
    private lazy var profileImage : UIImageView = {
        var view = UIImageView(image: UIImage(named: "waffle.png")) // 임의의 예시, 추후 프로필 사진으로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileName: UILabel = {
        var view = UILabel()
        view.text = "username" // 임의의 예시, 추후 사용자 이름으로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var diaryButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(diaryButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    let dummy_day = "2024-01-31"
    private lazy var dummy_days = [getStringToDate(strDate: dummy_day) : [1, "green"]] // [남은 일의 수, 목표 색]
    
    private lazy var todoView : UITableView = {
        var tableView = UITableView()
      /*  tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive */
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
}

extension ToDoViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        reloadCalendarView(date: Calendar.current.date(from: dateComponents!))
        
    }
    
    // 캘린더에 todo 띄우기
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let date = dateComponents.date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateString = dateFormatter.string(from: date)
        
    //    var fontDesign: UIFontDescriptor.SystemDesign { get set }
    //    enum DecorationSize : 2, @unchecked Sendable
        
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
        }
        else{
            return nil
        }
        
        
    }
    
}
/*
extension ToDoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Return the desired height for the section header in this section
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Customize the header view and title label based on the section
        
        titleLabel.text = String(section)
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    } // section별 헤더
}


extension ToDoViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
  
}
