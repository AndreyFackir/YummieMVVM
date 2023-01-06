//
//  Coordinator.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 03.01.2023.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  var children: [Coordinator] { get set }
  func start()
}

extension Coordinator {
  func childDidFinish(_ coordinator: Coordinator) {
    for (index, child) in children.enumerated() {
      if child === coordinator {
        children.remove(at: index)
      }
    }
  }
}
