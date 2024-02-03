//
//  ToDoViewModel.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/30.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

// 유저 정보를 가져와서 저장
// getHomeUser로 유저 정보 가져옴
// user에 저장 
class HomeViewModel{
    private let homeUserService = HomeUserService.shared
    var user: HomeUser?
    func getHomeUser(userID: Int, completion: @escaping () -> Void) {
        HomeUserService.shared.getHomeUser(userID: userID) { (response) in
            switch(response) {
            case .success(let userData):
                if let data = userData as? HomeUser {
                    self.user = data
                }
                completion()
            case .requestErr(let message) :
                print("requestErr", message)
                completion()
            case .pathErr :
                print("pathErr")
                completion()
            case .serverErr :
                print("serveErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
                completion()
            case .unknownErr:
                print("unknownErr")
                completion()
            }
        }
    }

}
