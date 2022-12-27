//
//  MainViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import UIKit
import Combine
import ProgressHUD

final class MainViewModel {
  weak var navigation: LoginNavigationProtocol?
  @Published var dishes: AllDishes?
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Init
  
  init() {
    fetchDishes()
  }
  
  // MARK: - Actions
  
  private func fetchDishes() {
    ProgressHUD.show()
    NetworkService.shared.fetch(target: .fetchAllCategories, type: AllDishes?.self)
      .receive(on: DispatchQueue.main)
      .map { $0 }
      .sink { completion in
        switch completion {
          case .finished:
            ProgressHUD.dismiss()
          case .failure(let error):
            ProgressHUD.showError(error.localizedDescription)
        }
      } receiveValue: { [weak self] allDishes in
        self?.dishes = allDishes
      }
      .store(in: &subscriptions)
  }
}
