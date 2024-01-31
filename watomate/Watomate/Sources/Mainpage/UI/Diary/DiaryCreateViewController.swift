//
//  DiaryViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2024/01/08.
//

import UIKit
import SnapKit

class DiaryCreateViewController: PlainCustomBarViewController{
    lazy var viewModel = DiaryPreviewViewModel()
    lazy var createViewModel = DiaryCreateViewModel()
    var completionClosure: ((String) -> Void)?
    var existence : Bool = false
    var userID = 3
    
    @objc private func finishButtonTapped() {
        let entry = DiaryCreate(
            description: diaryTextField.text ?? "no context",
            visibility: diaryVisibility?.toString() ?? "PB",
            mood: moodNumber,
            color: backgroundColor ?? "system",
            emoji: emoji ?? "emoji",
            image: nil,
            created_by: 3,
            date: profileDate.text ?? "no date" // Format the date as required
        )
        
        if existence == false{
            createViewModel.createDiary(entry: entry)
        }
        else{
            createViewModel.patchDiary(userID: userID, date: receivedDateString ?? "no date", entry: entry)
        }
        print(existence)
        
        completionClosure?(emoji ?? "no emoji")
        navigationController?.popViewController(animated: true)
    }


    func getDiary(userID: Int, date: String) {
        viewModel.getDiary(userID: userID, date: date) {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }

    func updateUI() {
        diaryTextField.text = viewModel.diary?.description
        emojiView.setImage(nil, for: .normal)
        emojiView.setTitle(viewModel.diary?.emoji, for: .normal)
        if let visibilityString = viewModel.diary?.visibility,
           let visibilityEnum = DiaryVisibility.from(string: visibilityString) {
            visibilityButton.setTitle(visibilityEnum.rawValue, for: .normal)
        } else {
            visibilityButton.setTitle("공개설정", for: .normal)
        }
        if let mood = viewModel.diary?.mood {
            moodView.text = "\(mood)°"
            moodView.isHidden = false
        } else {
            moodView.isHidden = true
        }
        contentView.backgroundColor = UIColor(named: viewModel.diary?.color ?? "system")
        diaryMenuView.backgroundColor = UIColor(named: "system")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("일기")
        setLeftButtonStyle(symbolName:"xmark", title:nil)
        setRightButtonStyle(symbolName: nil, title:"완료")
        setLeftButtonAction(target: self, action: #selector(backButtonTapped))
        setRightButtonAction(target: self, action: #selector(finishButtonTapped))

        setupLayout()
        
        if existence == true {
            getDiary(userID: userID, date: receivedDateString ?? "no date")
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupLayout(){
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
         }
        contentView.addSubview(moodView)
        moodView.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).inset(36)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
         }
        
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(moodView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().multipliedBy(0.08)
         }
        contentView.addSubview(diaryTextField)
        diaryTextField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.6)
         }
        contentView.addSubview(diaryMenuView)
        diaryMenuView.snp.makeConstraints { make in
            make.top.equalTo(diaryTextField.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
         }
        
    }
    
    func setupProfile() {
        profileName.text = User.shared.username
        profileImage.setProfileImage()
    }
    
    var emoji : String? = nil
    @objc private func emojiButtonTapped() {
        let vc = EmojiViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            self.emoji = data
            self.updateEmojiButtonAppearance()
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func updateEmojiButtonAppearance() {
        if emoji == nil {
            emojiView.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        } else {
            emojiView.setImage(nil, for: .normal)
            emojiView.setTitle(emoji, for: .normal)
            emojiView.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        }
    }
    
    private lazy var emojiView: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "face.dashed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true //
        return button
    }()
    
    var moodNumber : Int? = nil
    @objc private func moodButtonTapped() {
        let vc = MoodViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            self.moodNumber = Int(data)
            self.updateMoodAppearance()
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func updateMoodAppearance() {
        if moodNumber == nil {
            moodView.text = "25°"
        } else {
            moodView.text = "\(moodNumber ?? 25)°"
        }
    }
    
    private lazy var moodView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.contentMode = .top
        return label
    }()
    
    private lazy var profileView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        view.addSubview(profileName)
        view.addSubview(profileDate)
        view.addSubview(visibilityButton)
        profileImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview() //추후 프로필 이미지 사이즈에 따라 변형
            make.leading.equalToSuperview()
            make.width.equalTo(view.snp.height)
         }
        profileName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
         }
        profileDate.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(profileName.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
         }
        visibilityButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(profileDate.snp.trailing).offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
         }
        return view
    }()
    
    var userProfile : String?
    
    private lazy var profileImage : SymbolCircleView = {
        let imageView = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        imageView.setBackgroundColor(.secondarySystemFill)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    var userName : String?
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.text = userName
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.contentMode = .top
        return label
    }()
    
    var receivedDateString: String?
    lazy var profileDate: UILabel = {
        var label = UILabel()
        label.text = receivedDateString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    var diaryVisibility: DiaryVisibility? = nil
    @objc private func visibilityButtonTapped() {
        let vc = DiaryVisibilityViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            if let selectedVisibility = DiaryVisibility(rawValue: data) {
                self.diaryVisibility = selectedVisibility
                self.updateVisibilityButtonAppearance()
            } else {
                print("Invalid visibility value: \(data)") //예외처리
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func updateVisibilityButtonAppearance() {
        if diaryVisibility == nil {
            visibilityButton.setTitle("공개 설정", for: .normal)
        } else {
            visibilityButton.setTitle(diaryVisibility?.rawValue, for: .normal)
        }
    }
    
    private lazy var visibilityButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemGray4
        button.setTitle("공개 설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()

    
    lazy var diaryTextField: UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "오늘은 어떤 하루였나요?" // 00님의 오늘은 어떤 하루였나요? <- 00에 이름
        view.contentVerticalAlignment = .top
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        return view
    }()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UITableView)
    }
    
    @objc func handleTap() {
        // 키보드가 올라와 있는 경우 키보드 내리기
        if diaryTextField.isFirstResponder {
            diaryTextField.resignFirstResponder()
        }
    }
    
    private lazy var diaryMenuView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundColorButton)
        backgroundColorButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
         }
        view.addSubview(moodButton)
        moodButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(backgroundColorButton.snp.trailing).offset(8)
         }
        return view
        
    }()
    
    private lazy var backgroundColorButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "paintbrush")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(backgroundColorButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemGray

        // Set a specific size for the button
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Set the content mode for the image view
        button.imageView?.contentMode = .scaleAspectFit
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var backgroundColor : String? = nil
    @objc private func backgroundColorButtonTapped() {
        let vc = BackgroundColorViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            self.backgroundColor = data
            self.updateBackgroundColor()
        }
        present(vc, animated: true, completion: nil)
    }

    private func updateBackgroundColor() {
        if backgroundColor == nil {
            contentView.backgroundColor = .systemBackground
        } else {
            setBackgroundColor(UIColor(named: backgroundColor ?? "system") ?? .systemBackground)
            diaryMenuView.backgroundColor = .systemBackground
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundColorButton.layer.cornerRadius = backgroundColorButton.bounds.height / 2
        backgroundColorButton.clipsToBounds = true
        
        moodButton.layer.cornerRadius = backgroundColorButton.bounds.height / 2
        moodButton.clipsToBounds = true
    }
    
    private lazy var moodButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "heart")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(moodButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemGray

        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.imageView?.contentMode = .scaleAspectFit
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

}
