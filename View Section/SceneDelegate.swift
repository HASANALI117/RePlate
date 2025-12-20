//
//  SceneDelegate.swift
//  RePlate
//
//  Created by Basem Elkhayat on 06/12/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

 
        let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
