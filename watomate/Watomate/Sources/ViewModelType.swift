//
//  ViewModelType.swift
//  Watomate
//
//  Created by 권현구 on 1/18/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
