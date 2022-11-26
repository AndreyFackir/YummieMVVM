//
//  Order.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 07.11.2022.
//

import Foundation

struct Orders: Codable {
    let status: Int
    let message: String
    let data: [DishOrders]
}

// MARK: - Datum
struct DishOrders: Codable {
    let id, name: String
    let dish: OrderDish
}

// MARK: - Dish
struct OrderDish: Codable {
    let id, name, dishDescription: String
    let image: String
    let calories: Int
    let category: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case dishDescription = "description"
        case image, calories, category
    }
}


