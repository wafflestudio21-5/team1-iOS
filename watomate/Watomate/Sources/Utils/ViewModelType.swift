//
//  ViewModelType.swift
//  Watomate
//
//  Created by 이지현 on 1/16/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
