//
//  DiaryPreviewViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import Alamofire

class DiaryPreviewViewController: SheetCustomViewController {
    lazy var viewModel = DiaryPreviewViewModel()
    var receivedDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("일기")
        hideOkButton()
        setLeftButtonStyle(symbolName: "xmark")
        setRightButtonStyle(symbolName: "ellipsis")
        sheetView.addSubview(diaryPreviewView)
        diaryPreviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }
        setLeftButtonAction(action: #selector(leftButtonTapped))
        getDiary(userID: 3, date: receivedDateString ?? "2024-01-01")
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
        emojiView.setTitle(viewModel.diary?.emoji, for: .normal)
        if let visibilityString = viewModel.diary?.visibility,
           let visibilityEnum = DiaryVisibility.from(string: visibilityString) {
            visibilityLabel.text = visibilityEnum.rawValue
        } else {
            visibilityLabel.text = "전체공개"
        }

        if let mood = viewModel.diary?.mood {
            moodView.text = "\(mood)°"
            moodView.isHidden = false
        } else {
            moodView.isHidden = true
        }
        diaryPreviewView.backgroundColor = UIColor(named: viewModel.diary?.color ?? "system")
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
        button.setTitle(viewModel.diary?.emoji, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true //
        return button
    }()
    
    private lazy var moodView : UILabel = {
        var label = UILabel()
        label.text = String(viewModel.diary?.mood ?? 25) // 마음온도, 변경
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
    
    
    lazy var profileDate: UILabel = {
        var label = UILabel()
        label.text = receivedDateString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var visibilityLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var diaryTextField: UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentVerticalAlignment = .top
        return view
    }()
 

}

    

