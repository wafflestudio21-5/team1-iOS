//
//  NetworkManager.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    let session: Session

    private init() {
        session = Session(interceptor: Interceptor())
    }
}
