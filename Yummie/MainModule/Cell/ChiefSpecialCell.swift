//
//  ChiefSpecialCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 31.10.2022.
//

import UIKit
import Combine

final class ChiefSpecialCell: UICollectionViewCell {
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - View Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    chiefSpecialImage.image = nil
  }
  
  
  // MARK: - Properties
  
  private let chiefSpecialImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.layer.cornerRadius = 10
    element.contentMode = .scaleAspectFill
    element.layer.masksToBounds = true
    return element
  }()
  
  private let chiefSpecialTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoLight20
    element.textColor = .black
    return element
  }()
  
  private let caloriesTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .red
    element.font = .sanFranciscoLight15
    return element
  }()
  
  private let descriptionTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .gray
    element.font = .sanFranciscoLight20
    return element
  }()
  
  // MARK: - Methods
  func configureCell(with model: Dish , indexPath: Int) {
    chiefSpecialTitle.text = model.name
    caloriesTitle.text = "\(model.calories) kCal"
    descriptionTitle.text = model.description
    let imageUrl = model.image
    chiefSpecialImage.loadImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: {image in
        self.chiefSpecialImage.image = image
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Setup
private extension ChiefSpecialCell {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    addSubview(chiefSpecialImage)
    addSubview(chiefSpecialTitle)
    addSubview(caloriesTitle)
    addSubview(descriptionTitle)
    layer.cornerRadius = 10
    backgroundColor = .white
    addShadowOnView()
  }
  
  func setConstraints() {
    chiefSpecialImage.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview().inset(10)
      make.width.equalToSuperview().multipliedBy(0.2)
    }
    chiefSpecialTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(10)
      make.leading.equalTo(chiefSpecialImage.snp_trailingMargin).inset(-20)
      make.trailing.equalToSuperview().inset(5)
    }
    descriptionTitle.snp.makeConstraints { make in
      make.top.equalTo(chiefSpecialTitle.snp_bottomMargin).inset(-10)
      make.leading.equalTo(chiefSpecialImage.snp_trailingMargin).inset(-20)
      make.trailing.equalToSuperview().inset(5)
    }
    caloriesTitle.snp.makeConstraints { make in
      make.top.equalTo(descriptionTitle.snp_bottomMargin).inset(-10)
      make.leading.equalTo(chiefSpecialImage.snp_trailingMargin).inset(-20)
      make.trailing.equalToSuperview().inset(5)
    }
  }
}


