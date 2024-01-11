//
//  APIConstants.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/10.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Alamofire

struct APIConstants {
    static let baseURL = "http://toyproject-envs.eba-hwxrhnpx.ap-northeast-2.elasticbeanstalk.com/api"
    
    let diaryCreateURL = baseURL + "/diary-create"
    let diaryURL = baseURL + "/1/diarys/1"
}
