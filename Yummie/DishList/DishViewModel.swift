//
//  DishViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 15.11.2022.
//

import UIKit
import Combine
import ProgressHUD

final class DishViewModel {
  var dishCategory: DishCategory?
  @Published var dish: CategoryDishes?
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Init
  
  init(dishCategory: DishCategory) {
    self.dishCategory = dishCategory
    fetchCategoryDishes()
  }
  
  // MARK: - Actions
  
  private func fetchCategoryDishes() {
    ProgressHUD.show()
    NetworkService.shared.fetch(target: .fetchCategoryDishes(dishCategory?.id ?? ""), type: CategoryDishes?.self)
      .receive(on: DispatchQueue.main)
      .map { $0 }
      .sink { completion in
        switch completion {
          case .finished:
            ProgressHUD.dismiss()
          case .failure(let error):
            ProgressHUD.showError(error.localizedDescription)
        }
      } receiveValue: { [weak self] categoryDish in
        self?.dish = categoryDish
      }
      .store(in: &subscriptions)
  }
}
