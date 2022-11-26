//
//  SceneDelegate.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 26.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    var controller = UIViewController()
    if UserDefaults.standard.isOnbardingViewed {
      controller = HomeViewController()
    } else {
      controller = OnboardingViewController()
    }
    let navigationVC = UINavigationController(rootViewController: controller)
    window?.rootViewController = navigationVC
    window?.makeKeyAndVisible()
    
  }
  
}

