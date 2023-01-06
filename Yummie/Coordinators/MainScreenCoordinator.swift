//
//  MainScreenCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.01.2023.
//

import UIKit

final class MainScreenCoordinator: Coordinator {
  
  
  var parentCoordinator: Coordinator?
  var children: [Coordinator] = []
  var navigationController: UINavigationController
  
  // MARK: - Init
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  
  func start() {
    showMainScreen()
    print("MainScreenCoordinator start")
  }
  
  deinit {
    print("MainScreenCoordinator deinit")
  }
  
  func showMainScreen() {
    let homeVC = HomeViewController()
    let viewModel = MainViewModel()
    homeVC.mainViewModel = viewModel
    viewModel.coordinator = self
    parentCoordinator = self
    navigationController.pushViewController(homeVC, animated: true)
  }
  
  func goToOrdersList() {
    let ordersList = OrderListViewController()
    let viewModel = OrdersViewModel()
    ordersList.ordersViewModel = viewModel
    navigationController.pushViewController(ordersList, animated: true)
  }
  
  func goToProfile() {
    let profile = ProfileViewController()
    let viewModel = ProfileViewModel()
    profile.viewModel = viewModel
    viewModel.coordinator = self
    navigationController.pushViewController(profile, animated: true)
  }
}
