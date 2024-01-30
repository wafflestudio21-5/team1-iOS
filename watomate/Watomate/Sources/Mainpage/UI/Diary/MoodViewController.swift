//
//  MoodViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/27.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class MoodViewController: SheetCustomViewController {
    
    var moodNumber = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("기분 온도")
        sheetView.addSubview(moodView)
        moodView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        sheetView.addSubview(moodSlider)
        moodSlider.snp.makeConstraints { make in
            make.top.equalTo(moodView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        sheetView.addSubview(sliderLabelView)
        sliderLabelView.snp.makeConstraints { make in
            make.top.equalTo(moodSlider.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        okButtonAction(target: self, action: #selector(okButtonTapped))

    }

    @objc private func okButtonTapped() {
        onDismiss?(String(moodNumber))
        dismiss(animated: true, completion: nil)
    }

    private lazy var moodView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sadLabel)
        sadLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        view.addSubview(moodLabel)
        moodLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        view.addSubview(happyLabel)
        happyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return view
    }()
    
    private lazy var moodLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var sadLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "😢"
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var happyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "😊"
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var moodSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.addTarget(self, action: #selector(onChangeValueSlider(sender:)), for: UIControl.Event.valueChanged)
        updateMoodLabel(value: Int(slider.value))
        return slider
    }()
    
    private lazy var sliderLabelView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zeroLabel)
        zeroLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        view.addSubview(hundredLabel)
        hundredLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return view
    }()
    
    private lazy var zeroLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var hundredLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    @objc func onChangeValueSlider(sender: UISlider){
        let roundedValue = round(sender.value)
       updateMoodLabel(value: Int(roundedValue))
       sender.value = roundedValue
    }
    
    func updateMoodLabel(value: Int) {
        moodLabel.text = "\(value)°"
        moodNumber = value
    }
    
    
}
