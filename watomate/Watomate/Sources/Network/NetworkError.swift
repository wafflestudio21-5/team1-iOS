//
//  NetworkError.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case notFound
    case methodError
    case unprocessableEntity
    case serverError
    case tooLargeError
    case internetOffline
    case timeout
    case decodingError
    case otherError
    case kakaoLoginError
    case errorWithMessage(message: String)
    
    var statusCode: Int {
        switch self {
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .notFound:
            return 404
        case .methodError:
            return 405
        case .unprocessableEntity:
            return 422
        case .serverError:
            return 500
        case .tooLargeError:
            return 413
        default:
            return -1
        }
    }
}

extension NetworkError {
    static func error(from statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 404:
            return .notFound
        case 405:
            return .methodError
        case 422:
            return .unprocessableEntity
        case 500:
            return .serverError
        case 413:
            return .tooLargeError
        default:
            return nil
        }
    }
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
        case .methodError:
            return NSLocalizedString("Method Not Allowed", comment: "Method Not Allowed")
        case .unprocessableEntity:
            return NSLocalizedString("Unprocessable Entity", comment: "Unprocessable Entity")
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
        case .errorWithMessage(let message):
            return NSLocalizedString(message, comment: message)
        case .tooLargeError:
            return NSLocalizedString("Request entity too large", comment: "Request entity too large")
        }
    }
}
