//
//  DiaryViewController.swift
//  WaToDoMate
//
//  Created by 이수민 on 2024/01/08.
//

import UIKit
import SnapKit

class DiaryCreateViewController: PlainCustomBarViewController{
    
    var completionClosure: ((String) -> Void)?
    
    @objc private func finishButtonTapped() {
        let diaryText = diaryTextField.text ?? "no context"
        let profileDate = profileDate.text ?? "no date"
        
        DiaryCreateService.shared.createDiary(diaryText: diaryText, date: profileDate){ (response) in
           // NetworkResult형 enum값을 이용해서 분기처리를 합니다.
           switch(response) {
           
           // 성공할 경우에는 <T>형으로 데이터를 받아올 수 있다고 했기 때문에 Generic하게 아무 타입이나 가능하기 때문에
           // 클로저에서 넘어오는 데이터를 let personData라고 정의합니다.
           case .success(let diaryData):
               // personData를 Person형이라고 옵셔널 바인딩 해주고, 정상적으로 값을 data에 담아둡니다.
               if let data = diaryData as? Diary {
                   print("\(data.date)")
               }
           // 실패할 경우에 분기처리는 아래와 같이 합니다.
           case .requestErr(let message) :
               print("requestErr", message)
           case .pathErr :
               print("pathErr")
           case .serverErr :
               print("serveErr")
           case .networkFail:
               print("networkFail")
               
           }
       } //안됨
         /*
        
        DiaryService.shared.patchDiary(diaryText: diaryText, date: profileDate){ (response) in
           switch(response) {
           case .success(let diaryData):
               if let data = diaryData as? Diary {
                   print("\(data.id)")
               }
           case .requestErr(let message) :
               print("requestErr", message)
           case .pathErr :
               print("pathErr")
           case .serverErr :
               print("serveErr")
           case .networkFail:
               print("networkFail")
           }
       }*/
        completionClosure?(emoji) //emoji todoVC로 보내기
        navigationController?.popViewController(animated: true)
    } //수정 필요

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("일기")
        setLeftButtonStyle(symbolName:"xmark", title:nil)
        setRightButtonStyle(symbolName: nil, title:"완료")
        setLeftButtonAction(target: self, action: #selector(backButtonTapped))
        setRightButtonAction(target: self, action: #selector(finishButtonTapped))
        // Do any additional setup after loading the view.
        setupLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupLayout(){
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.top.equalToSuperview() //추후 프로필 이미지 사이즈에 따라 변형
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
         }
        
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().multipliedBy(0.08)

         }
        
        contentView.addSubview(diaryTextField)
        diaryTextField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)//추후 프로필 이미지 사이즈에 따라 변형
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.6)
         }
        
        contentView.addSubview(diaryMenuView)
        diaryMenuView.snp.makeConstraints { make in
            make.top.equalTo(diaryTextField.snp.bottom)//추후 프로필 이미지 사이즈에 따라 변형
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.1)
         }
        
    }
    
    var emoji = "?"
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
        if emoji == "?" {
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
        return button
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
    
    private lazy var profileImage : UIImageView = {
        var view = UIImageView(image: UIImage(named: "waffle.jpg")) // 임의의 예시, 추후 프로필 사진으로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.text = "User" // 임의의 예시, 추후 사용자 이름으로 변경
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
    
    var visibility = "?"
    @objc private func visibilityButtonTapped() {
        let vc = DiaryVisibilityViewController()
        setSheetLayout(for: vc)
        vc.onDismiss = { data in
            self.visibility = data
            self.updateVisibilityButtonAppearance()
        }
        present(vc, animated: true, completion: nil)
    }

    private func updateVisibilityButtonAppearance() {
        if visibility == "?" {
            visibilityButton.setTitle("공개 설정", for: .normal)
        } else {
            visibilityButton.setTitle(visibility, for: .normal)
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
    
    @objc func privacyButtonTapped() {
       let privacysetViewController = DiaryVisibilityViewController()
       navigationController?.pushViewController(privacysetViewController, animated: false)
   }
    
    lazy var diaryTextField: UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "오늘은 어떤 하루였나요?" // 00님의 오늘은 어떤 하루였나요? <- 00에 이름
        view.contentVerticalAlignment = .top
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
    
    //
    
    private lazy var diaryMenuView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundColorButton)
        backgroundColorButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
 
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
    
   // var visibility = "?"
    @objc private func backgroundColorButtonTapped() {
        let vc = BackgroundColorViewController()
        setSheetLayout(for: vc)
        /*
        vc.onDismiss = { data in
            self.visibility = data
            self.updateVisibilityButtonAppearance()
        }
         */
        present(vc, animated: true, completion: nil)
    }
/*
    private func updateVisibilityButtonAppearance() {
        if visibility == "?" {
            visibilityButton.setTitle("공개 설정", for: .normal)
        } else {
            visibilityButton.setTitle(visibility, for: .normal)
        }
    }
*/
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update corner radius after layout is complete
        backgroundColorButton.layer.cornerRadius = backgroundColorButton.bounds.height / 2
        backgroundColorButton.clipsToBounds = true
    }



    
    
    

   
  

}
