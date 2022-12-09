//
//  OrderListViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 17.11.2022.
//

import UIKit
import Combine
import SnapKit

class OrderListViewController: UIViewController {
  
  let ordersViewModel = OrdersViewModel()
  private var subscriptions: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    binding()
    
  }
  
  // MARK: - Properties
  private let orderListCollection: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environ in
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      return section
    }
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.showsVerticalScrollIndicator = false
    collection.backgroundColor = .specialBackground
    return collection
  }()
  
  // MARK: - Actions
  
  private func binding() {
    ordersViewModel.$orders
      .receive(on: DispatchQueue.main)
      .sink { _ in self.orderListCollection.reloadData() }
      .store(in: &subscriptions)
  }
  
}
// MARK: - Setup

extension OrderListViewController {
  
  private func setup() {
    setupViews()
    setConstraints()
  }
  
  private func setupViews() {
    view.addSubview(orderListCollection)
    orderListCollection.dataSource = self
    orderListCollection.delegate = self
    orderListCollection.register(OrderCollectionViewCell.self, forCellWithReuseIdentifier: "orderList")
  }
  
  private func setConstraints() {
    orderListCollection.snp.makeConstraints { make in
      make.top.leading.bottom.trailing.equalToSuperview()
    }
  }
}
// MARK: - UICollectionViewDataSource
extension OrderListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ordersViewModel.orders?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderList", for: indexPath) as? OrderCollectionViewCell else { return .init() }
    
    guard let model = ordersViewModel.orders?.data[indexPath.item] else { return .init() }
    cell.configureCell(model: model)
    return cell
  }
  
  
}
// MARK: - UICollectionViewDelegate
extension OrderListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let dishOrders = ordersViewModel.orders?.data[indexPath.item] else { return }
    let detailVM = DetailViewModel(dishOrders: dishOrders)
    let detailVC = DetialViewController(detailViewModel: detailVM)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
