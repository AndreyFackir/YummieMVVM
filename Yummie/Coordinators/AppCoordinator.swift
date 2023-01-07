//
//  AppCoordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.01.2023.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
  
  // MARK: - Properties
  var navigationController: UINavigationController
  var children: [Coordinator] = []
  var parentCoordinator: Coordinator?
  let hasSeenOnboarding = CurrentValueSubject<Bool, Never>(false)
  var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Init
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    setupOnboardingValue()
    
    hasSeenOnboarding
      .removeDuplicates()
      .sink { [weak self] hasSeen in
        if hasSeen {
          self?.goToAuth()
        } else {
          self?.showOnboard()
        }
      }
      .store(in: &subscriptions)
    
    print("AppCoordinator start")
  }
  
  deinit {
    print("AppCoordinator deinit")
  }
  
  func showOnboard() {
    let onboard = OnboardingCoordinator(navigationController: navigationController, hasSeenOnboarding: hasSeenOnboarding)
    onboard.parentCoordinator = self
    children.append(onboard)
    onboard.start()
  }
  
  func goToAuth() {
    let auth = AuthCoordinator(navigationController: navigationController)
    auth.parentCoordinator = self
    children.append(auth)
    auth.start()
  }
  
  func goToMain() {
    let mainCoord = MainScreenCoordinator(navigationController: navigationController)
    mainCoord.parentCoordinator = self
    children.append(mainCoord)
    mainCoord.start()
  }

  private func setupOnboardingValue() {
    let key = "hasSeenOnboarding"
    let value = UserDefaults.standard.bool(forKey: key)
    print(value)
    hasSeenOnboarding.send(value)
    
    hasSeenOnboarding
      .filter { $0 }
      .sink { value in
        UserDefaults.standard.set(value, forKey: key)
      }
      .store(in: &subscriptions)
  }
}
