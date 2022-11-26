//
//  Constants.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import Foundation

enum Constants {
  static let baseUrl = "https://yummie.glitch.me"
  case fetchAllCategories
  case placeOrder(String)
  case fetchCategoryDihes(String)
  case fetchOrders
  
  var description: String {
    switch self {
      case .fetchAllCategories:
        return "/dish-categories"
      case .placeOrder(let dishId):
        return "/orders/\(dishId)"
      case .fetchCategoryDihes(let categoryId):
        return "/dishes/\(categoryId)"
      case .fetchOrders:
        return "/orders"
    }
  }
}
