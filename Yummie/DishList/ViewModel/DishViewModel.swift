//
//  DishViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 15.11.2022.
//

import UIKit
import Combine
import ProgressHUD

class DishViewModel {
  
  // MARK: - Properties
  var dishCategory: DishCategory?
  @Published var dish: CategoryDishes?
  private var subscriptions: Set<AnyCancellable> = []
  
  init(dishCategory: DishCategory) {
    self.dishCategory = dishCategory
   fetchCategoryDishes()
  }
  
  // MARK: - Actions
  
  private func fetchCategoryDishes() {
    ProgressHUD.show()
    NetworkService.shared.fetchCategoryDishes(categoryDish: dishCategory?.id ?? "")
      .receive(on: DispatchQueue.main)
      .map { $0 }
      .sink { completion in
        switch completion {
          case .finished:
            ProgressHUD.dismiss()
          case .failure(let error):
            ProgressHUD.showError(error.localizedDescription)
        }
      } receiveValue: { [weak self] dish in
        self?.dish = dish
      }
      .store(in: &subscriptions)
    
    
  }
  
  }
