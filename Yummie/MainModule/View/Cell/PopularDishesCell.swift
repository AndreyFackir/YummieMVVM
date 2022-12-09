//
//  PopularDishesCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 31.10.2022.
//

import UIKit
import Combine

class PopularDishesCell: UICollectionViewCell {
  
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - View life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    dishImage.image = nil
  }
  
  
  // MARK: - Properties
  
  private let dishImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.contentMode = .scaleAspectFill
    element.layer.cornerRadius = 10
    element.clipsToBounds = true
    return element
  }()
  
  private let dishNameTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .black
    element.font = .sanFranciscoLight20
    return element
  }()
  
  private let caloriesTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoLight15
    element.textColor = .red
    return element
  }()
  
   var descriptionTitle: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .gray
    element.font = .sanFranciscoLight15
    return element
  }()
  
  // MARK: - Actions
  func configureCell(with model: Dish , indexPath: Int) {
    dishNameTitle.text = model.name
    caloriesTitle.text = "\(model.calories) kCal"
    descriptionTitle.text = model.description
    let imageUrl = model.image
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
extension PopularDishesCell {
  
  private func setup() {
    setupViews()
    setConstraints()
  }
  
  private func setupViews() {
    addSubview(dishImage)
    addSubview(dishNameTitle)
    addSubview(caloriesTitle)
    addSubview(descriptionTitle)
    layer.cornerRadius = 10
    backgroundColor = .white
    addShadowOnView()
  }
  
  private func setConstraints() {
    dishNameTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(10)
      make.centerX.equalToSuperview()
    }
    
    dishImage.snp.makeConstraints { make in
      make.top.equalTo(dishNameTitle.snp_bottomMargin).inset(-10)
      make.leading.equalToSuperview().inset(5)
      make.trailing.equalToSuperview().inset(5)
      make.bottom.equalTo(caloriesTitle.snp_topMargin).inset(-10)
    }
    
    caloriesTitle.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(10)
      make.bottom.equalTo(descriptionTitle.snp_topMargin).inset(-10)
    }
    
    descriptionTitle.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(10)
      make.bottom.equalToSuperview().inset(5)
    }
    
  }
}

