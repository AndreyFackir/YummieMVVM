//
//  NetworkService.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.11.2022.
//

import UIKit
import Combine

final class NetworkService {
  
  // MARK: - Properties
  
  static let shared = NetworkService()
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Actions
  
  func fetchDishes() -> AnyPublisher<AllDishes, Error> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      guard let url = URL(string: Constants.baseUrl + Constants.fetchAllCategories.description) else { return }
      URLSession.shared.dataTaskPublisher(for: url)
        .catch { error in return Fail(error: error) }
        .map { $0.data }
        .decode(type: AllDishes.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink { _ in
          
        } receiveValue: { dishes in
          promise(.success(dishes))
        }
        .store(in: &self.subscriptions)
    }
    .eraseToAnyPublisher()
  }
  
  func fetchCategoryDishes(categoryDish: String) -> AnyPublisher<CategoryDishes, Error> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      guard let url = URL(string: Constants.baseUrl + Constants.fetchCategoryDihes(categoryDish).description) else { return }
      URLSession.shared.dataTaskPublisher(for: url)
        .receive(on: DispatchQueue.main)
        .catch { error in Fail(error: error) }
        .map { $0.data }
        .decode(type: CategoryDishes.self, decoder: JSONDecoder())
        .sink { _ in
          
        } receiveValue: { dish in
          promise(.success(dish))
        }
        .store(in: &self.subscriptions)
    }
    .eraseToAnyPublisher()
  }
  
  func placeOrder(id: String, name: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: Constants.baseUrl + Constants.placeOrder(id).description) else { return }
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
  
  func fetchOrders() -> AnyPublisher<Orders, Error> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      guard let url = URL(string: Constants.baseUrl + Constants.fetchOrders.description) else { return }
      URLSession.shared.dataTaskPublisher(for: url)
        .catch { error in return Fail(error: error) }
        .map { $0.data }
        .decode(type: Orders.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink { _ in
          
        } receiveValue: { order in
          print(order)
          promise(.success(order))
        }
        .store(in: &self.subscriptions)
    }
    .eraseToAnyPublisher()
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
