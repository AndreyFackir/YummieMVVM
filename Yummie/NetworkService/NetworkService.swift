//
//  NetworkService.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import UIKit
import Combine

enum NetworkTarget {
  case fetchAllCategories
  case placeOrder(String)
  case fetchCategoryDishes(String)
  case fetchOrders
  
  var link: String {
    switch self {
      case .fetchAllCategories:
        return Constants.baseUrl + "/dish-categories"
      case .placeOrder(let dishId):
        return Constants.baseUrl + "/orders/\(dishId)"
      case .fetchCategoryDishes(let categoryId):
        return Constants.baseUrl + "/dishes/\(categoryId)"
      case .fetchOrders:
        return Constants.baseUrl + "/orders"
    }
  }
}

final class NetworkService {
  
  // MARK: - Properties
  
  static let shared = NetworkService()
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Actions
  
  func fetch<T:Decodable>(target: NetworkTarget, type: T.Type) -> AnyPublisher<T, Error> {
    return Future { [ weak self ] promise in
      guard let self = self else { return }
      guard let url = URL(string: target.link) else { return }
      URLSession.shared.dataTaskPublisher(for: url)
        .catch { error in Fail(error: error) }
        .receive(on: DispatchQueue.main)
        .map { $0.data }
        .decode(type: type, decoder: JSONDecoder())
        .sink { _ in
          
        } receiveValue: { T in
          promise(.success(T))
        }
        .store(in: &self.subscriptions)
    }
    .eraseToAnyPublisher()
  }
  
  
  func placeOrder(id: String, target: NetworkTarget, name: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: target.link) else { return }
    let orderData = ["name": "\(name)"]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    guard let httpBody = try? JSONSerialization.data(withJSONObject: orderData, options: []) else { return }
    request.httpBody = httpBody
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, _, error in
      guard let data = data else { return }
      do {
        let _ = try JSONSerialization.jsonObject(with: data, options: [])
        completion(.success(data))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
  
  
  private func handleResponce(data: Data?, responce: URLResponse?) -> UIImage? {
    guard let data = data,
          let image = UIImage(data: data),
          let response = responce as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode <= 300 else { return nil }
    return image
  }
  
  func getImage(url: String) -> AnyPublisher<UIImage?, Error> {
    guard let imageUrl = URL(string: url) else { fatalError("Invalid Url")}
    return URLSession.shared.dataTaskPublisher(for: imageUrl)
      .receive(on: DispatchQueue.main)
      .map(handleResponce)
      .mapError({ $0 })
      .eraseToAnyPublisher()
  }
}
