//
//  OnboardingCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 05.01.2023.
//

import UIKit
import Combine

final class OnboardingCoordinator: Coordinator {
  
  // MARK: - Properties
  var navigationController: UINavigationController
  var parentCoordinator: Coordinator?
  var children: [Coordinator] = []
  var hasSeenOnboarding: CurrentValueSubject<Bool, Never>
  
  // MARK: - Init
  init(navigationController: UINavigationController, hasSeenOnboarding: CurrentValueSubject<Bool, Never> ) {
    self.navigationController = navigationController
    self.hasSeenOnboarding = hasSeenOnboarding
  }
  
  // MARK: - Methods
  func start() {
    showOnboarding()
    print("OnboardingCoordinator start")
    print("OnboardingCoordinator - \(parentCoordinator)")
  }
  
  deinit {
    print("OnboardingCoordinator deinit")
  }
  
  func showOnboarding() {
    let onboardingVC = OnboardingViewController()
    let viewModel = OnboardingViewModel()
    onboardingVC.viewModel = viewModel
    viewModel.coordinator = self
    navigationController.pushViewController(onboardingVC, animated: false)
  }
  
  func goToAuth() {
    let appC = parentCoordinator as! AppCoordinator
    appC.goToAuth()
    parentCoordinator?.childDidFinish(self)
  }
}
