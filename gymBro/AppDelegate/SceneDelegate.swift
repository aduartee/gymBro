//
//  SceneDelegate.swift
//  gymBro
//
//  Created by Arthur Duarte on 12/07/24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            print("Erro to connect the scene")
            return
        }
        
        configureMainWindow(windowScene: windowScene)
        print("Connection was success")
    }
    
    func validateAuthenticateUser() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser == nil {
            let signInVC = storyboard.instantiateViewController(withIdentifier: "singInViewController") as! ViewController
            let navigationController = UINavigationController(rootViewController: signInVC)
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController = navigationController
        } else {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navigationController = UINavigationController(rootViewController: homeVC)
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController = navigationController
            
            if let currentUser = Auth.auth().currentUser {
                print("Nome: \(currentUser.displayName ?? "Sem nome de exibição")")
                print("Email: \(currentUser.email ?? "Sem email")")
            }
        }
    }
    
    func configureMainWindow(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        validateAuthenticateUser()
        window?.makeKeyAndVisible()
    }
    
}

