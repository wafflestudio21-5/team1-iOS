//
//  SearchDiaryCell.swift
//  Watomate
//
//  Created by 이지현 on 1/22/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchDiaryCellDelegate: AnyObject {
    func searchDiaryCell(_ searchDiaryCell: SearchDiaryCell, userId: Int, date:String)
}

class SearchDiaryCell: UITableViewCell {
    static let reuseIdentifier = "DiaryCell"
    private var viewModel: SearchDiaryCellViewModel?
    weak var delegate: SearchDiaryCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileCircleView.reset()
        usernameLabel.text = nil
        dateLabel.text = nil
        moodStackView.isHidden = true
        moodLabel.text = nil
        descriptionLabel.text = nil
        likeCircleView.setBackgroundColor(.systemGray6)
        likeCircleView.setSymbolColor(.systemGray4)
    }
    
    private lazy var containerView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10.adjusted
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var headerView = {
       let view = UIView()
        
        profileCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.headerViewHeight)
        }
        
        view.addSubview(profileCircleView)
        profileCircleView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileCircleView.snp.trailing).offset(Constants.SearchDiary.offset)
        }
        
        view.addSubview(statusStackView)
        statusStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.top.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var profileCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "person.fill"))
        view.setBackgroundColor(.systemGray5)
        view.setSymbolColor(.systemBackground)
        return view
    }()
    
    private lazy var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5.adjusted
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        return stackView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.semiBold, size: 16.adjusted)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont(name: Constants.Font.regular, size: 13.adjusted)
        return label
    }()
    
    private lazy var statusStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 5.adjusted
        
        stackView.addArrangedSubview(moodStackView)
        stackView.addArrangedSubview(emojiLabel)
        return stackView
    }()
    
    private lazy var moodStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4.adjusted
        view.distribution = .equalCentering
        view.isHidden = true
        
        view.addArrangedSubview(moodLabel)
        view.addArrangedSubview(moodBar)
        return view
    }()
    
    private lazy var moodLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.bold, size: 10.adjusted)
        return label
    }()
    
    private lazy var moodBar = {
        let bar = UIProgressView()
        bar.clipsToBounds = true
        bar.layer.cornerRadius = 3.adjusted
        bar.progressTintColor = UIColor(red: 236.0/255.0, green: 110.0/255.0, blue: 223.0/255.0, alpha: 1)
        bar.trackTintColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        
        bar.snp.makeConstraints { make in
            make.width.equalTo(32.adjusted)
            make.height.equalTo(6.adjusted)
        }
        return bar
    }()
    
    private lazy var emojiLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 29.adjusted)
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: Constants.Font.regular, size: 16.adjusted)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var footerView = {
        let view = UIView()
        likeCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.SearchDiary.footerViewHeight)
        }
        
        view.addSubview(likeCircleView)
        likeCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var likeCircleView = {
        let view = SymbolCircleView(symbolImage: UIImage(systemName: "heart.fill"))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTapped)))
        view.isUserInteractionEnabled = true 
        return view
    }()
    
    @objc func likeTapped() {
        if let viewModel,
           let delegate {
            delegate.searchDiaryCell(self, userId: viewModel.userId, date: viewModel.date)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.SearchDiary.containerHorizontalInset)
            make.top.bottom.equalToSuperview().inset(Constants.SearchDiary.containerVerticalInset)
        }
        
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
            make.height.equalTo(Constants.SearchDiary.headerViewHeight)
        }
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.SearchDiary.offset)
            make.leading.trailing.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
        }
        
        containerView.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.SearchDiary.offset)
            make.height.equalTo(Constants.SearchDiary.footerViewHeight)
            make.leading.trailing.bottom.equalToSuperview().inset(Constants.SearchDiary.contentsInset)
        }
        
    }
    
    func configure(with viewModel: SearchDiaryCellViewModel) {
        self.viewModel = viewModel
        usernameLabel.text = viewModel.username
        dateLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
        if let profilePic = viewModel.profilePic {
            profileCircleView.setImage(profilePic)
        } else {
            profileCircleView.setDefault()
        }
        if let mood = viewModel.mood {
            moodLabel.text = "\(mood)°"
            moodBar.setProgress(Float(mood) / 100.0 , animated: false)
            moodStackView.isHidden = false
        }
        containerView.backgroundColor = viewModel.color.uiColor
        emojiLabel.text = viewModel.emoji
        usernameLabel.textColor = viewModel.color.label
        moodLabel.textColor = viewModel.color.label
        descriptionLabel.textColor = viewModel.color.label
        dateLabel.textColor = viewModel.color.secondaryLabel
        
        likeCircleView.setBackgroundColor(viewModel.color.heartBackground)
        likeCircleView.setSymbolColor(viewModel.color.heartSymbol)
    }
    
}
