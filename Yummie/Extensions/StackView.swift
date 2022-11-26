//
//  StackView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 31.10.2022.
//

import UIKit

extension UIStackView {
  convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
    self.init(arrangedSubviews: arrangedSubviews)
    self.axis = axis
    self.spacing = spacing
    self.translatesAutoresizingMaskIntoConstraints = false
  }
}
