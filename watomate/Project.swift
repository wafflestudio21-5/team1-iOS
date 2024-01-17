import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: Plist.Value] = [
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true,
    ],
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ],
                    ]
                ]
            ],
    "UIAppFonts": [
        "Pretendard-Black.otf",
        "Pretendard-Bold.otf",
        "Pretendard-ExtraBold.otf",
        "Pretendard-ExtraLight.otf",
        "Pretendard-Light.otf",
        "Pretendard-Medium.otf",
        "Pretendard-Regular.otf",
        "Pretendard-SemiBold.otf",
        "Pretendard-Thin.otf",
    ],
    "LSApplicationQueriesSchemes": [
        "kakaolink",
        "kakaokompassauth",
    ],
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": "kakao"
        ],
    ],
    "UISupportedInterfaceOrientations":
    [
        "UIInterfaceOrientationPortrait",
    ],
]

let destination: Set<ProjectDescription.Destination> = [.iPhone]

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Watomate",
                          destinations: destination,
                          infoPlist: infoPlist,
                          dependencies: [
                            .external(name: "SnapKit"),
                            .external(name: "Alamofire"),
                            .external(name: "KakaoSDK")
                         ])
