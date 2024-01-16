//
//  NetworkError.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case internetOffline
    case timeout
    case decodingError
    case otherError
    case kakaoLoginError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request", comment: "Bad Request")
        case .unauthorized:
                    return NSLocalizedString("Unauthorized", comment: "Unauthorized")
        case .notFound:
            return NSLocalizedString("Not Found", comment: "Not Found")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "Server Error")
        case .internetOffline:
            return NSLocalizedString("Internet Connection Offline", comment: "No Internet Connection")
        case .timeout:
            return NSLocalizedString("Request Timed Out", comment: "Timeout")
        case .decodingError:
            return NSLocalizedString("Data Decoding Error", comment: "Decoding Error")
        case .otherError:
            return NSLocalizedString("Unknown Error Occurred", comment: "Other Error")
        case .kakaoLoginError:
            return NSLocalizedString("Kakao Login Error", comment: "Kakao Login Error")
        }
    }
}
