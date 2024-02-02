import KakaoSDKCommon
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        if let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] {
//            if let urlSchemes = urlTypes[0]["CFBundleURLSchemes"] as? [String] {
//                let appKey = urlSchemes[0]
//                let startIndex = appKey.index(appKey.startIndex, offsetBy: 5)
//                KakaoSDK.initSDK(appKey: String(appKey[startIndex...]))
//            }
//        }
        
        KakaoSDK.initSDK(appKey: "bc3d466403d1a451cdc43038925a906e")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    


}
