//
//  Dependencies.swift
//  Config
//
//  Created by 이지현 on 12/31/23.
//

import ProjectDescription

let swiftPackgageManager = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.1")),
    .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.8.1"))
])

let dependencies = Dependencies(
    swiftPackageManager: swiftPackgageManager,
    platforms: [.iOS]
)
