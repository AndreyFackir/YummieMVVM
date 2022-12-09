//
//  MainViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 28.10.2022.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
  
  enum Section: String, CaseIterable {
    case foodCategory = "Food Category"
    case popularDishes = "Popular Dishes"
    case chiefSpecials = "Chief's Specials"
  }
  
  private var subscriptions: Set<AnyCancellable> = []
  private let mainViewModel = MainViewModel()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindings()
  }
  
  // MARK: - Properties
  
  private let homeCollection: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environ in
      let section = Section.allCases[sectionIndex]
      switch section {
          
        case .foodCategory:
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)), subitems: [item])
          let section = NSCollectionLayoutSection(group: group)
          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
          section.boundarySupplementaryItems = [sectionHeader]
          section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
          return section
          
        case .popularDishes:
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.37)), subitems: [item])
          let section = NSCollectionLayoutSection(group: group)
          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
          section.boundarySupplementaryItems = [sectionHeader]
          section.orthogonalScrollingBehavior = .continuous
          section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
          return section
          
        case .chiefSpecials:
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)))
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.37)), subitems: [item])
          let section = NSCollectionLayoutSection(group: group)
          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
          section.boundarySupplementaryItems = [sectionHeader]
          section.orthogonalScrollingBehavior = .continuous
          return section
      }
    }
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.showsVerticalScrollIndicator = false
    return collection
  }()
  
  // MARK: - Actions
  
  @objc private func cartButtonTapped() {
    let orderVC = OrderListViewController()
    navigationController?.pushViewController(orderVC, animated: true)
  }
  
  private func bindings() {
    mainViewModel.$dishes
      .receive(on: DispatchQueue.main)
      .sink { _ in self.homeCollection.reloadData() }
      .store(in: &subscriptions)
  }
}
// MARK: - Setup
private extension HomeViewController {
  
  func setup() {
    setupViews()
    setConstraints()
    setupNavigationBar()
    setHomeCollection()
  }
  func setupViews() {
    title = "YUMMIE"
    view.backgroundColor = .specialBackground
    view.addSubview(homeCollection)
  }
  
  func setHomeCollection() {
    homeCollection.dataSource = self
    homeCollection.delegate = self
    homeCollection.backgroundColor = .specialBackground
    homeCollection.register(HomeFoodCategoryCell.self, forCellWithReuseIdentifier: "homeCell")
    homeCollection.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    homeCollection.register(PopularDishesCell.self, forCellWithReuseIdentifier: "popularDishes")
    homeCollection.register(ChiefSpecialCell.self, forCellWithReuseIdentifier: "special")
  }
  
  private func setConstraints() {
    homeCollection.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }
  
  func setupNavigationBar() {
    let cartImage = UIBarButtonItem(image: UIImage(systemName: "cart.circle.fill"), style: .plain, target: self, action: #selector(cartButtonTapped))
    navigationController?.topViewController?.navigationItem.rightBarButtonItem = cartImage
    cartImage.tintColor = .red
  }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    Section.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section.allCases[section] {
      case .foodCategory:
        return mainViewModel.dishes?.data.categories.count ?? 0
      case .popularDishes:
        return mainViewModel.dishes?.data.populars.count ?? 0
      case .chiefSpecials:
        return mainViewModel.dishes?.data.specials.count ?? 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch Section.allCases[indexPath.section] {
        
      case .foodCategory:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? HomeFoodCategoryCell else { return .init() }
        guard let cat = mainViewModel.dishes?.data.categories[indexPath.item] else { return .init() }
        cell.configureCell(with: cat, indexPath: indexPath.row)
        return cell
        
      case .popularDishes:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularDishes", for: indexPath) as? PopularDishesCell else { return .init()}
        guard let model = mainViewModel.dishes?.data.populars[indexPath.item] else { return .init() }
        cell.configureCell(with: model, indexPath: indexPath.row)
        return cell
        
      case .chiefSpecials:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "special", for: indexPath) as? ChiefSpecialCell else { return .init() }
        guard let model = mainViewModel.dishes?.data.specials[indexPath.item] else { return .init() }
        cell.configureCell(with: model, indexPath: indexPath.row)
        return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TitleSupplementaryView else { return .init() }
    header.headerLabel.text = Section.allCases[indexPath.section].rawValue
    return header
  }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section.allCases[indexPath.section] {
      case .foodCategory:
        guard let dishCategory = mainViewModel.dishes?.data.categories[indexPath.item] else { return }
        let dishViewModel = DishViewModel(dishCategory: dishCategory)
        let dishList = DishListViewController(dishViewModel: dishViewModel)
        navigationController?.pushViewController(dishList, animated: true)
        
      case .popularDishes:
        guard let dish = mainViewModel.dishes?.data.populars[indexPath.item] else { return }
        let detailVM = DetailViewModel(dish: dish)
        let detailVC = DetialViewController(detailViewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
        
      case .chiefSpecials:
        guard let chiefSpecial = mainViewModel.dishes?.data.specials[indexPath.item] else { return }
        let detailVM = DetailViewModel(dish: chiefSpecial)
        let detailVC = DetialViewController(detailViewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
  }
}
