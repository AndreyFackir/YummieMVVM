//
//  UITextField.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 07.11.2022.
//

import Combine
import UIKit

extension UITextField {
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap {$0.object as? UITextField }
      .compactMap (\.text)
      .eraseToAnyPublisher()
  }
}
