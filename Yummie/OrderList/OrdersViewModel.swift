//
//  OrdersViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 17.11.2022.
//

import UIKit
import Combine
import ProgressHUD

final class OrdersViewModel {
  weak var coordinator: MainScreenCoordinator?
  @Published var orders: Orders?
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - Init
  
  init() {
    fetchOrders()
  }
  
  // MARK: - Actions
  
  private func fetchOrders() {
    ProgressHUD.show()
    NetworkService.shared.fetch(target: .fetchOrders, type: Orders?.self)
      .receive(on: DispatchQueue.main)
      .map { $0 }
      .sink { completion  in
        switch completion {
          case .finished:
            ProgressHUD.dismiss()
          case .failure(let error):
            ProgressHUD.showError(error.localizedDescription)
        }
      } receiveValue: { [weak self] orders in
        self?.orders = orders
      }
      .store(in: &subscriptions)
  }
  
  
}
