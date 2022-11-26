//
//  MainViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import UIKit
import Combine
import ProgressHUD

class MainViewModel {
  
  // MARK: - Properties
  @Published var dishes: AllDishes?
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Actions
  
  init() {
    fetchDishes()
  }
  
  private func fetchDishes() {
    ProgressHUD.show()
    NetworkService.shared.fetchDishes()
      .receive(on: DispatchQueue.main)
      .map { $0 }
      .sink { completion in
        switch completion {
          case .finished:
            ProgressHUD.dismiss()
          case .failure(let error):
            ProgressHUD.showError(error.localizedDescription)
        }
      } receiveValue: { [weak self] dishes in
        self?.dishes = dishes
        
      }
      .store(in: &subscriptions)
  }
}
