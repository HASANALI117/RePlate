import UIKit
import FirebaseCore
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase configuration
        FirebaseApp.configure()
        
        // Enable offline persistence for Realtime Database
        Database.database().isPersistenceEnabled = true
        
        // Generate test data for demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            FirebaseManager.shared.generateTestData()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}