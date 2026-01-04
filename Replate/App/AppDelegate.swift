//
//  AppDelegate.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser != nil {
            let tabBarVC = storyboard.instantiateViewController(
                withIdentifier: "MainTabBarController"
            )
            window?.rootViewController = tabBarVC
        } else {
            let loginNav = storyboard.instantiateViewController(
                withIdentifier: "LoginNavigationController"
            )
            window?.rootViewController = loginNav
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}
