//
//  DatePickerViewController.swift
//  Watomate
//
//  Created by 권현구 on 1/29/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

class DatePickerViewController: SheetCustomViewController {
    
    private lazy var datePickerView = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .date
        pickerView.preferredDatePickerStyle = .inline
        pickerView.timeZone = TimeZone(identifier: "Asia/Seoul")
        return pickerView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setTitle("날짜 바꾸기")
        okButtonAction(target: self, action: #selector(handleOkBtnTap))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetView.addSubview(datePickerView)
        
        datePickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func handleOkBtnTap() {
        print(datePickerView.date)
        dismiss(animated: true)
    }
}
