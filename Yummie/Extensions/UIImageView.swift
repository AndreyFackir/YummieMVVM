//
//  UIImageView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 10.12.2022.
//

import UIKit
import Combine

extension UIImageView {
  private func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
    guard let data = data,
          let image = UIImage(data: data),
          let response = response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode <= 300 else { return nil }
    return image
  }
  
  func loadImage(url: String) -> AnyPublisher<UIImage?, Error> {
    guard let imageUrl = URL(string: url) else { fatalError("Invalid Url")}
    return URLSession.shared.dataTaskPublisher(for: imageUrl)
      .receive(on: DispatchQueue.main)
      .map(handleResponse)
      .mapError({ $0 })
      .eraseToAnyPublisher()
  }
}
