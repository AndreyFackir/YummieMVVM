//
//  HomeFirstSectionCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 28.10.2022.
//

import UIKit
import Combine


class HomeFoodCategoryCell: UICollectionViewCell {
  
  private var subscriptions: Set<AnyCancellable> = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    foodCategoryImage.image = nil
  }
  
//  override var isSelected: Bool {
//    didSet {
//      if isSelected {
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.red.cgColor
//      } else {
//        layer.borderWidth = 0
//      }
//    }
//  }
  
  // MARK: - Properties
  
   let foodCategoryImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.layer.masksToBounds = true
    element.contentMode = .scaleAspectFit
    return element
  }()
  
  let foodCategoryTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .black
    element.font = .sanFranciscoLight15
    return element
  }()
  
  // MARK: - Actions
  func configureCell(with model: DishCategory , indexPath: Int) {
    foodCategoryTitle.text = model.title
    let imageUrl = model.image
    NetworkService.shared.getImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in

      } receiveValue: { [weak self] image in
        self?.foodCategoryImage.image = image
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Setup
extension HomeFoodCategoryCell {
  
  private func setup() {
    setupViews()
    setConstraints()
  }
  
  private func setupViews() {
    addSubview(foodCategoryImage)
    addSubview(foodCategoryTitle)
    layer.cornerRadius = 10
    backgroundColor = .white
    addShadowOnView()
  }
  
  private func setConstraints() {
    foodCategoryImage.snp.makeConstraints { make in
      make.width.height.equalToSuperview().multipliedBy(0.7)
      make.centerX.equalToSuperview()
    }
    
    foodCategoryTitle.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(5)
      make.centerX.equalToSuperview()
    }
  }
}
