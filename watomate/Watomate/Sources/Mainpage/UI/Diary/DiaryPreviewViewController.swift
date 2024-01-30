//
//  DiaryPreviewViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import Alamofire

protocol DiaryPreviewViewControllerDelegate: AnyObject {
    func diaryPreviewViewControllerDidRequestDiaryCreation(_ controller: DiaryPreviewViewController)
}

class DiaryPreviewViewController: SheetCustomViewController {
    weak var delegate: DiaryPreviewViewControllerDelegate?
    lazy var viewModel = DiaryPreviewViewModel()
    var receivedDateString: String?
    var userID = 3 //로그인이랑 연동해서 수정!!
    
    
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
        setRightButtonAction(action: #selector(rightButtonTapped))
        getPreviewDiary(userID: userID, date: receivedDateString ?? "no date") //유저아이디 수정, date 오늘로 수정?
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        adjustLayoutForSize(view.bounds.size)
    }

    private func adjustLayoutForSize(_ size: CGSize) {
        guard let sheet = self.sheetPresentationController else { return }
        let isCustomDetent: Bool

        switch sheet.selectedDetentIdentifier {
        case UISheetPresentationController.Detent.Identifier.large:
            isCustomDetent = false
        case UISheetPresentationController.Detent.Identifier("customDetent"):
            isCustomDetent = true
        default:
            isCustomDetent = true
        }
        
        let moodViewTopOffset = isCustomDetent ? 10 : 20
        let profileViewTopOffset = isCustomDetent ? 10 : 20
        let diaryTextFieldTopOffset = isCustomDetent ? 12 : 24

        emojiView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(isCustomDetent ? 0.2 : 0.15)
        }
        
        moodView.snp.remakeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).offset(moodViewTopOffset)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(isCustomDetent ? 0.1 : 0.05)
        }
        
        profileView.snp.remakeConstraints { make in
            make.top.equalTo(moodView.snp.bottom).offset(profileViewTopOffset)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().multipliedBy(isCustomDetent ? 0.3 : 0.08)
        }
        
        diaryTextField.snp.remakeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(diaryTextFieldTopOffset)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(isCustomDetent ? 0.35 : 0.5)
        }
        
        if !isCustomDetent {
            if likeView.superview == nil {
                diaryPreviewView.addSubview(likeView)
            }
            if commentView.superview == nil {
                diaryPreviewView.addSubview(commentView)
            }
            likeView.snp.remakeConstraints { make in
                make.top.equalTo(diaryTextField.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalToSuperview().multipliedBy(0.1)
            }
            
            commentView.snp.remakeConstraints { make in
                make.top.equalTo(likeView.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
            }
        } else {
            likeView.removeFromSuperview()
            commentView.removeFromSuperview()
        }
    }

    
    func getPreviewDiary(userID: Int, date: String) {
        viewModel.getDiary(userID: userID, date: date) {
            DispatchQueue.main.async { [weak self] in
                self?.updatePreviewUI()
            }
        }
    }

    func updatePreviewUI() {
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
        sheetView.backgroundColor = UIColor(named: viewModel.diary?.color ?? "system")
        
    }

    @objc func rightButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.delegate?.diaryPreviewViewControllerDidRequestDiaryCreation(self!)
        }

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.viewModel.deleteDiary(userID: self.userID, date: self.receivedDateString ?? "no date")
        }

        let doneAction = UIAlertAction(title: "완료", style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(doneAction)
       
        present(actionSheet, animated: true)
    }

    private lazy var diaryPreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiView)
        view.addSubview(moodView)
        view.addSubview(profileView)
        view.addSubview(diaryTextField)
        
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
    
    var userProfile : String?
    private lazy var profileImage : UIImageView = {
        var view = UIImageView(image: UIImage(named: "waffle.jpg")) // 임의의 예시, 추후 프로필 사진으로 변경
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var userName : String?
    private lazy var profileName: UILabel = {
        var label = UILabel()
        label.text = userName // 임의의 예시, 추후 사용자 이름으로 변경
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
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        
        return view
    }()
 
    private lazy var likeView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var commentView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

    

