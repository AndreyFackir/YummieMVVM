//
//  DetailViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 05.11.2022.
//

import UIKit
import ProgressHUD
import Combine

final class DetailViewModel {
  @Published var dish: Dish?
  @Published var order: Orders?
  @Published var nameTextField = ""
  @Published var datum: Datum?
  @Published var dishOrders: DishOrders?
  private var subscriptions: Set<AnyCancellable> = []
  let nameText = PassthroughSubject<String, Never>()
  
  // MARK: - Init
  init(){}
  
  convenience init(dish: Dish) {
    self.init()
    self.dish = dish
  }
  
  convenience init(datum: Datum) {
    self.init()
    self.datum = datum
  }
  
  convenience init(dishOrders: DishOrders) {
    self.init()
    self.dishOrders = dishOrders
  }
  
  
  // MARK: - Actions
  
  func placeOrder(id: String, name: String) {
    NetworkService.shared.placeOrder(id: id, target: .placeOrder(id), name: name) { completion in
      switch completion {
        case .success(_):
          ProgressHUD.showSuccess("Your order has been placed")
        case .failure(let error):
          ProgressHUD.showError(error.localizedDescription)
      }
    }
  }
  
  func placeDiffOrders(name: String) {
    if dish == nil {
      guard let categoryDishId = datum?.id else { return }
      placeOrder(id: categoryDishId, name: name)
    } else {
      guard let dishId = dish?.id else { return }
      placeOrder(id: dishId, name: name)
    }
  }
}
