//
//  AuthCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 05.01.2023.
//

import UIKit
import Combine

final class AuthCoordinator: Coordinator {
  
  // MARK: - Properties
  var parentCoordinator: Coordinator?
  var navigationController: UINavigationController
  var children: [Coordinator] = []
  var hasAuthorized: CurrentValueSubject<Bool, Never>

  
  // MARK: - Init
  init(navigationController: UINavigationController, hasAuthorized: CurrentValueSubject<Bool, Never>) {
    self.navigationController = navigationController
    self.hasAuthorized = hasAuthorized
  }
  
  // MARK: - Methods
  func start() {
    goToLogin()
    print("AuthCoordinator start")
    print("AuthCoordinator - \(parentCoordinator)")
  }
  
  deinit {
    print("AuthCoordinator deinit")
  }
  
  func goToLogin() {
    let authVC = LoginViewController()
    let viewModel = LoginViewModel()
    authVC.viewModel = viewModel
    viewModel.coordinator = self
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
    let appC = parentCoordinator as! AppCoordinator
    appC.goToMain()
    parentCoordinator?.childDidFinish(self)
  }
}
