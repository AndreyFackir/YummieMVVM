//
//  DishListCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 01.11.2022.
//

import UIKit
import SnapKit
import Combine

final class DishListCell: UICollectionViewCell {
  private var subscriptions: Set<AnyCancellable> = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  private let dishImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.layer.cornerRadius = 15
    element.layer.masksToBounds = true
    element.contentMode = .scaleAspectFill
    return element
  }()
  
  private let dishTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoMedium20
    return element
  }()
  
  private let dishDescription: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoLight15
    element.textColor = .gray
    return element
  }()
  
  // MARK: - Actions
  
  func configureCell(model: Datum) {
    dishTitle.text = model.name
    dishDescription.text = model.description
    let imageUrl = model.image
    dishImage.loadImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: {image in
        self.dishImage.image = image
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Setup

private extension DishListCell {
  
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    addSubview(dishImage)
    addSubview(dishTitle)
    addSubview(dishDescription)
    layer.cornerRadius = 15
    backgroundColor = .white
    addShadowOnView()
  }
  
  func setConstraints() {
    dishImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.height.equalToSuperview().multipliedBy(0.9)
      make.width.equalToSuperview().multipliedBy(0.15)
      make.centerY.equalToSuperview()
    }
    dishTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalTo(dishImage.snp.trailingMargin).offset(20)
      make.trailing.equalToSuperview().inset(10)
    }
    dishDescription.snp.makeConstraints { make in
      make.top.equalTo(dishTitle.snp.bottom).offset(10)
      make.leading.equalTo(dishImage.snp.trailingMargin).offset(20)
      make.trailing.equalToSuperview().inset(10)
    }
  }
}
