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
  let hasAuthorized = CurrentValueSubject<Bool, Never>(false)
  var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Init
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    setupOnboardingValue()
    setupAuthorizationValue()
    
    hasSeenOnboarding.combineLatest(hasAuthorized)
      .removeDuplicates(by: { prev, current in
        prev == current
      })
      .sink { [weak self] hasSeen, hasAuth in
        if hasSeen && hasAuth {
          self?.goToMain()
        } else if hasSeen {
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
    let auth = AuthCoordinator(navigationController: navigationController, hasAuthorized: hasAuthorized)
    children.removeAll()
    auth.parentCoordinator = self
    children.append(auth)
    auth.start()
  }
  
  func goToMain() {
    let mainCoord = MainScreenCoordinator(navigationController: navigationController)
    children.removeAll()
    mainCoord.parentCoordinator = self
    children.append(mainCoord)
    mainCoord.start()
  }
  
  private func setupOnboardingValue() {
    let key = "hasSeenOnboarding"
    let value = UserDefaults.standard.bool(forKey: key)
    print("hasSeenOnboarding - \(value)")
    hasSeenOnboarding.send(value)
    
    hasSeenOnboarding
      .removeDuplicates()
      .filter { $0 }
      .sink { value in
        UserDefaults.standard.set(value, forKey: key)
      }
      .store(in: &subscriptions)
  }
  
  private func setupAuthorizationValue() {
    let key = "hasAuthorized"
    let value = UserDefaults.standard.bool(forKey: key)
    hasAuthorized.send(value)
    print("hasAuth - \(value)")
    hasAuthorized
      .filter { $0 }
      .sink { value in
        UserDefaults.standard.set(value, forKey: key)
      }
      .store(in: &subscriptions)
  }
}
