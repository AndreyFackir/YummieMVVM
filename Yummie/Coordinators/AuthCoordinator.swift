//
//  AuthCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 05.01.2023.
//

import UIKit

final class AuthCoordinator: Coordinator {
  
  weak var coordinator: AppCoordinator?
  var parentCoordinator: Coordinator?
  var navigationController: UINavigationController
  var children: [Coordinator] = []
  
  // MARK: - Init
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    goToLogin()
    print("AuthCoordinator start")
  }

  deinit {
    print("AuthCoordinator deinit")
  }
 
  func goToLogin() {
    let authVC = LoginViewController()
    let viewModel = LoginViewModel()
    authVC.viewModel = viewModel
    viewModel.coordinator = self
//    children.append(self)
    navigationController.viewControllers.removeAll()
    navigationController.pushViewController(authVC, animated: true)
  }
  
  func goToRegister() {
    let registerVC = RegisterViewController()
    let viewModel = RegisterViewModel()
    registerVC.viewModel = viewModel
    viewModel.coordinator = self
    navigationController.pushViewController(registerVC, animated: true)
  }
  
  func goToMain() {
    let appC = AppCoordinator(navigationController: navigationController)
    appC.goToMain()
    parentCoordinator?.childDidFinish(self)
  }
}
