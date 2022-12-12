//
//  Model.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 16.11.2022.
//

import Foundation

// MARK: - Dishes
struct CategoryDishes: Codable {
  let status: Int
  let message: String
  let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
  let id, name, description: String
  let image: String
  let calories: Int
  let category: Category
}

enum Category: String, Codable {
  case cat1 = "cat1"
  case cat2 = "cat2"
  case cat3 = "cat3"
  case cat4 = "cat4"
  case cat5 = "cat5"
}

