//
//  View.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 04.11.2022.
//

import UIKit

extension UIView {
  func addShadowOnView() {
    layer.shadowColor = UIColor.gray.cgColor
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 1
  }
}
