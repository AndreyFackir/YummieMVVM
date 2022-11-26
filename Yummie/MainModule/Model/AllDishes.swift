//
//  Model.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import Foundation

struct AllDishes: Decodable {
    let status: Int
    let message: String
    let data: Dishes
}

struct Dishes: Decodable {
  let categories: [DishCategory]
  let populars: [Dish]
  let specials: [Dish]
 
}

struct DishCategory: Decodable {
  let id, title: String
  let image: String
}

struct Dish: Decodable {
  let id, name, description, image: String
  let calories: Int
}




