//
//  SceneDelegate.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 26.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController.init()
    appCoordinator = AppCoordinator(navigationController: navigationController)
    appCoordinator?.start()
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    //
    //    var controller = UIViewController()
    //    if UserDefaults.standard.isOnbardingViewed {
    //      controller = LoginViewController()
    //    } else {
    //      controller = OnboardingViewController()
    //    }
    //    let navigationVC = UINavigationController(rootViewController: controller)
    
  }
  
}

