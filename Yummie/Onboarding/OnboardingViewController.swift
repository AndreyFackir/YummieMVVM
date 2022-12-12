//
//  ViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 26.10.2022.
//

import UIKit
import SnapKit
import Combine

final class OnboardingViewController: UIViewController {
  
  private let viewModel = OnboardingViewModel()
  private var subscriptions: Set<AnyCancellable> = []
  @Published var buttonTapped = 0
  
  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindings()
  }
  
  // MARK: - Properties
  private lazy var nextButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Next", for: .normal)
    element.titleLabel?.font = .sanFranciscoMedium20
    element.layer.cornerRadius = 25
    element.tintColor = .white
    element.backgroundColor = .darkGray
    element.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    return element
  }()
  
  private let pageControl: UIPageControl = {
    let element = UIPageControl()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.isEnabled = false
    element.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    return element
  }()
  
  private let onboardingCollection: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { section, environ in
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .paging
      return section
    }
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.backgroundColor = .black
    collection.showsHorizontalScrollIndicator = false
    collection.isUserInteractionEnabled = false
    return collection
  }()
  
  // MARK: - Methods
  
  @objc private func nextButtonTapped() {
    buttonTapped += 1
    $buttonTapped
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        self.viewModel.buttonTappedCount.send(value)
        let index: IndexPath = [0, value]
        self.onboardingCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        self.pageControl.currentPage = value
        if value == 3 {
          let mainVC = HomeViewController()
          mainVC.modalPresentationStyle = .fullScreen
          self.present(mainVC, animated: true, completion: nil)
        }
      }.store(in: &subscriptions)
  }
  
  private func bindings() {
    viewModel.$buttonTitle
      .receive(on: DispatchQueue.main)
      .sink { [weak self] title in
        guard let self = self else { return }
        self.nextButton.setTitle(title, for: .normal)
        self.pageControl.numberOfPages = self.viewModel.configureScreens().count
      }
      .store(in: &subscriptions)
  }
}

// MARK: - setupUI
private extension OnboardingViewController {
  func setup() {
    setupViews()
    setConstraints()
    setOnboardingCollection()
  }
  
  func setupViews() {
    view.addSubview(nextButton)
    view.addSubview(pageControl)
    view.addSubview(onboardingCollection)
  }
  
  func setOnboardingCollection() {
    onboardingCollection.register(OnboardingCell.self, forCellWithReuseIdentifier: "onboardingCell")
    onboardingCollection.dataSource = self
  }
  
  func setConstraints() {
    nextButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(100)
      make.centerX.equalTo(view.snp_centerXWithinMargins)
      make.height.equalTo(50)
      make.width.equalTo(250)
    }
    pageControl.snp.makeConstraints { make in
      make.centerX.equalTo(view.snp_centerXWithinMargins)
      make.bottom.equalTo(nextButton.snp_topMargin).inset(-20)
    }
    onboardingCollection.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(pageControl.snp_topMargin).inset(-20)
    }
  }
}
// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.configureScreens().count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as? OnboardingCell else { return .init() }
    let model = viewModel.configureScreens()[indexPath.row]
    cell.configure(model: model)
    return cell
  }
}
