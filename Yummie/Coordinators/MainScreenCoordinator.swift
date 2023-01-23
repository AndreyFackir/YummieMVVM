//
//  MainScreenCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.01.2023.
//

import UIKit

final class MainScreenCoordinator: Coordinator {
  
  // MARK: - Properties
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
    print("MainScreenCoordinator - \(parentCoordinator)")
  }
  
  deinit {
    print("MainScreenCoordinator deinit")
  }
  
  func showMainScreen() {
//    let homeVC = HomeViewController()
//    let viewModel = MainViewModel()
//    homeVC.mainViewModel = viewModel
//    viewModel.coordinator = self
//    navigationController.pushViewController(homeVC, animated: true)
    let containerVC = ContainerViewController()
    let viewModel = ContainerViewModel()
    containerVC.viewModel = viewModel
    viewModel.coordinator = self
    navigationController.pushViewController(containerVC, animated: true)
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
  
  func goToDishList(dishCategory: DishCategory) {
    let viewModel = DishViewModel(dishCategory: dishCategory)
    let dishListVC = DishListViewController(dishViewModel: viewModel)
    viewModel.coordinator = self
    navigationController.pushViewController(dishListVC, animated: true)
  }
  
  func goToDetail(dish: Dish) {
    let viewModel = DetailViewModel(dish: dish)
    let detailVC = DetialViewController(detailViewModel: viewModel)
    viewModel.coordinator = self
    navigationController.pushViewController(detailVC, animated: true)
  }
  
  func goToAuth() {
    let appC = parentCoordinator as! AppCoordinator
    appC.goToAuth()
    parentCoordinator?.childDidFinish(self)
  }
}
