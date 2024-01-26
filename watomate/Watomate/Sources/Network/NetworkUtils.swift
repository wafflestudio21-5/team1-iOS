//
//  NetworkUtils.swift
//  Watomate
//
//  Created by 이지현 on 1/15/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Alamofire
import Foundation


class Interceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Token \(User.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
}

extension DataTask {
    @discardableResult func handlingError() async throws -> Value {
        let response = await response
        switch response.result {
        case let .success(dto):
            return dto
        case let .failure(error):
            if let data = response.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let errorDto = try? decoder.decode(ErrorDto.self, from: data) {
                    throw NetworkError.errorWithMessage(message: errorDto.errorMsg)
                }
                if let errorDto = try? decoder.decode(UsernameErrorDto.self, from: data) {
                    throw NetworkError.errorWithMessage(message: errorDto.username[0])
                }
            }
            if let statusCode = response.response?.statusCode {
                print(statusCode)
                if let networkError = NetworkError.error(from: statusCode) {
                    throw networkError
                }
            }
            if let afError = error.asAFError {
                switch afError {
                case .responseSerializationFailed(let reason):
                    switch reason {
                    case .decodingFailed:
                        throw NetworkError.decodingError
                    default:
                        throw NetworkError.otherError
                    }
                case .sessionTaskFailed(let error):
                    if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            throw NetworkError.internetOffline
                        case .timedOut:
                            throw NetworkError.timeout
                        default:
                            throw NetworkError.otherError
                        }
                    }
                default:
                    throw NetworkError.otherError
                }
            }
        }
            throw NetworkError.otherError
    }
}
