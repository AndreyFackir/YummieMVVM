//
//  OrderCollectionViewCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 17.11.2022.
//

import UIKit
import Combine

class OrderCollectionViewCell: UICollectionViewCell {
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
  
  let dishTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoMedium20
    return element
  }()
  
  private let clientName: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoLight15
    element.textColor = .gray
    return element
  }()
  
  // MARK: - Actions
  
  func configureCell(model: DishOrders) {
    dishTitle.text = model.dish.name
    clientName.text = model.name
    let imageUrl = model.dish.image
    NetworkService.shared.getImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] image in
        self?.dishImage.image = image
      }
      .store(in: &subscriptions)
  }
}
// MARK: - Setup

extension OrderCollectionViewCell {
  
  private func setup() {
    setupViews()
    setConstraints()
  }
  
  private func setupViews() {
    addSubview(dishImage)
    addSubview(dishTitle)
    addSubview(clientName)
    layer.cornerRadius = 15
    backgroundColor = .white
    addShadowOnView()
  }
  
  private func setConstraints() {
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
    
    clientName.snp.makeConstraints { make in
      make.top.equalTo(dishTitle.snp.bottom).offset(10)
      make.leading.equalTo(dishImage.snp.trailingMargin).offset(20)
      make.trailing.equalToSuperview().inset(10)
    }
  }
}
