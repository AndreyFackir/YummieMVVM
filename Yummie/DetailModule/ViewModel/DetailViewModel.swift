//
//  DetailViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 05.11.2022.
//

import UIKit
import ProgressHUD
import Combine

class DetailViewModel {
  
  // MARK: - Properties
  @Published var dish: Dish?
  @Published var order: Orders?
  @Published var nameTextField = ""
  @Published var datum: Datum?
  @Published var dishOrders: DishOrders?
  private var subscriptions: Set<AnyCancellable> = []
  let nameText = PassthroughSubject<String, Never>()
  
  init(dish: Dish) {
    self.dish = dish
  }
  
  init(datum: Datum) {
    self.datum = datum
  }
  
  init(dishOrders: DishOrders) {
    self.dishOrders = dishOrders
  }
  
  
  // MARK: - Actions
  
  func getImage(from url: String, completion: @escaping (UIImage) -> Void) {
    guard let imageUrl = URL(string: url) else { return }
    URLSession.shared.dataTask(with: imageUrl) { data, _, error in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          completion(image)
        }
      }
    }.resume()
  }
  
  
  func placeOrder(id: String, name: String) {
    NetworkService.shared.placeOrder(id: id, name: name) { completion in
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
