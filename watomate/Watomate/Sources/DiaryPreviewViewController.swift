//
//  DiaryPreviewViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class DiaryPreviewViewController: SheetCustomViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("일기")
        hideOkButton()
        testServer()
        
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func testServer(){
        DiaryService.shared.getDiary{ (response) in
            // NetworkResult형 enum값을 이용해서 분기처리
            switch(response) {
                
                // 성공할 경우에는 <T>형으로 데이터를 받아올 수 있음 -  아무 타입이나 가능하기 때문에
                // 클로저에서 넘어오는 데이터를 let diaryData라고 정의
            case .success(let diaryData):
                // personData를 Person형이라고 옵셔널 바인딩 해주고, 정상적으로 값을 data에 담아둡니다.
                if let data = diaryData as? Diary {
                    self.textLabel.text = data.description
                    print(self.textLabel)
                }
                
                // 실패한 경우
            case .requestErr(let message) :
                print("requestErr", message)
            case .pathErr :
                print("pathErr")
            case .serverErr :
                print("serveErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
}
