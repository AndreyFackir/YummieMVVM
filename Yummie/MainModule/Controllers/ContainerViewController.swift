//
//  ContainerViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 23.01.2023.
//

import UIKit
import SnapKit

enum MenuState {
  case open
  case closed
}

final class ContainerViewController: UIViewController {
  
  let menuVC = MenuViewController()
  let homeVC = HomeViewController()
  var viewModel = ContainerViewModel()
  private var menuState: MenuState = .closed
  var navVC: UINavigationController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
  }
  
  // MARK: - Properties
  
  
  
  // MARK: - Methods
  private func addChildVC() {
    addChild(menuVC)
    view.addSubview(menuVC.view)
    menuVC.didMove(toParent: self)
    
    homeVC.delegate = self
    addChild(homeVC)
    view.addSubview(homeVC.view)
    homeVC.didMove(toParent: self)
  }
  
}

// MARK: -  Setup
private extension ContainerViewController {
  
  private func setup() {
    setupViews()
    addChildVC()
  }
  
  func setupViews() {
    title = "YUMMIE"
  }
 
}

// MARK: - HomeViewControllerDelegate
extension ContainerViewController: HomeViewControllerDelegate {
  func didMenuButtonTapped() {
    print("Menu tapped")
    
    switch menuState {
      case .open:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
          self.homeVC.view.frame.origin.x = 0
        } completion: { [weak self] done in
          if done {
            self?.menuState = .closed
          }
        }
        
      case .closed:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
          self.homeVC.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
        } completion: { [weak self] done in
          if done {
            self?.menuState = .open
          }
        }
    }
  }
  
  
}
