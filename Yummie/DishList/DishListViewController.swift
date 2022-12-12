//
//  DishListViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 01.11.2022.
//

import UIKit
import SnapKit
import Combine

final class DishListViewController: UIViewController {
  private var dishViewModel: DishViewModel
  private var subscriptions: Set< AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    binding()
    
  }
  
  init(dishViewModel: DishViewModel) {
    self.dishViewModel = dishViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Properties
  private let dishListCollection: UICollectionView = {
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
    dishViewModel.$dish
      .receive(on: DispatchQueue.main)
      .sink { _ in self.dishListCollection.reloadData() }
      .store(in: &subscriptions)
  }
}

// MARK: - Setup

private extension DishListViewController {
  
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    view.addSubview(dishListCollection)
    view.backgroundColor = .specialBackground
    dishListCollection.dataSource = self
    dishListCollection.delegate = self
    dishListCollection.register(DishListCell.self, forCellWithReuseIdentifier: "dishList")
  }
  
  func setConstraints() {
    dishListCollection.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }
}
// MARK: - UICollectionViewDataSource
extension DishListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    dishViewModel.dish?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dishList", for: indexPath) as? DishListCell else { return .init() }
    guard let model = dishViewModel.dish?.data[indexPath.item] else { return .init()}
    cell.configureCell(model: model)
    return cell
  }
}
// MARK: - UICollectionViewDelegate
extension DishListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let dish = dishViewModel.dish?.data[indexPath.item] else { return }
    let detailVM = DetailViewModel(datum: dish)
    let detailVC = DetialViewController(detailViewModel: detailVM)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
