//
//  DiaryPreviewViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class DiaryPreviewViewController: SheetCustomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("일기")
        hideOkButton()
        setLeftButtonStyle(symbolName: "xmark")
        setRightButtonStyle(symbolName: "ellipsis")
        setDiarySheetLayout(for: self)
        sheetView.addSubview(diaryPreviewView)
        diaryPreviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 추후 프로필 이미지 사이즈에 따라 변형
        }
        setLeftButtonAction(action: #selector(leftButtonTapped))
    }

    func setDiarySheetLayout(for viewController: SheetCustomViewController) {
        viewController.modalPresentationStyle = .pageSheet

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]  // Set the detent directly to .large()
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = true
        }
    }

    private lazy var diaryPreviewView: UIView = {
        let view = UIView()
        view.addSubview(emojiView)
        view.translatesAutoresizingMaskIntoConstraints = false
        emojiView.snp.makeConstraints { make in
            make.top.equalToSuperview() //추후 프로필 이미지 사이즈에 따라 변형
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
         }
        view.addSubview(moodView)
        moodView.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).inset(20) //추후 프로필 이미지 사이즈에 따라 변형
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
         }
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(moodView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().multipliedBy(0.08)
         }
        view.addSubview(diaryTextField)
        diaryTextField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.6)
         }
        return view
    }()
    
    
    private lazy var emojiView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("😊", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true //
        return button
    }()
    
    private lazy var moodView : UILabel = {
        var label = UILabel()
        label.text = "50" // 마음온도, 변경
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.contentMode = .top
        return label
    }()
    
    private lazy var profileView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        view.addSubview(profileName)
        view.addSubview(profileDate)
        view.addSubview(visibilityLabel)
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
        visibilityLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(profileName.snp.bottom)
            make.leading.equalTo(profileDate.snp.trailing).offset(4)
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
    
    var receivedDateString = "2024-01-27"
    lazy var profileDate: UILabel = {
        var label = UILabel()
        label.text = receivedDateString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var visibilityLabel : UILabel = {
        let label = UILabel()
        label.text = "전체공개"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var diaryTextField: UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "오늘의 다이어리" // 00님의 오늘은 어떤 하루였나요? <- 00에 이름
        view.contentVerticalAlignment = .top
        return view
    }()
 

}

    

