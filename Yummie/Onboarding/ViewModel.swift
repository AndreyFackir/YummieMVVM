//
//  ViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 27.10.2022.
//

import UIKit
import Combine

final class OnboardingViewModel {
  
  // MARK: - Properties
  weak var coordinator: OnboardingCoordinator?
  var onboardingModel: OnboardingModel?
  var buttonTappedCount = PassthroughSubject<Int, Never>()
  private var subscriptions: Set<AnyCancellable> = []
  @Published var buttonTitle = "Next"
  
  // MARK: - Init
  
  init() {
    nextButtonTapped()
  }
  
  // MARK: - Methods
  
  func configureScreens() -> [OnboardingModel] {
    var onboardingArray = [OnboardingModel]()
    guard let firstImage = UIImage(named: "slide1"),
          let secondImage = UIImage(named: "slide2"),
          let thirdImage = UIImage(named: "slide3") else { return .init() }
    
    let firstScreen = OnboardingModel(topInfoLabel: "Delicious Dishes", description: "Experience of variety of amazing dishes from different cultures around the world", image: firstImage)
    let secondScreen = OnboardingModel(topInfoLabel: "World Class Chiefs", description: "Our dishes is cooked by 3 star Michelin professionals", image: secondImage)
    let thirdScreen = OnboardingModel(topInfoLabel: "Worldwide Delivery", description: "Your orders will be delivered to your door", image: thirdImage)
    onboardingArray = [firstScreen, secondScreen, thirdScreen]
    return onboardingArray
  }
  
  private func nextButtonTapped() {
    buttonTappedCount
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] value in
        if value == 2 {
          self?.buttonTitle = "Let's go"
        }
        if value == 3 {
          self?.coordinator?.hasSeenOnboarding.send(true)
          self?.coordinator?.goToAuth()
          
        }
      }.store(in: &subscriptions)
  }
}


