//
//  OnboardingCell.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 26.10.2022.
//

import UIKit
import SnapKit

final class OnboardingCell: UICollectionViewCell {
  
  // MARK: - View Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  private let topLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.font = .sanFranciscoMedium40
    element.textAlignment = .center
    element.textColor = .white
    element.numberOfLines = 0
    return element
  }()
  
  private let image: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.image = UIImage(named: "first")
    element.contentMode = .scaleAspectFit
    return element
  }()
  
  private let bottomLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .white
    element.font = .sanFranciscoLight20
    element.textAlignment = .center
    element.numberOfLines = 0
    return element
  }()
  
  // MARK: - Actions
  
  func configure(model: OnboardingModel) {
    topLabel.text = model.topInfoLabel
    bottomLabel.text = model.description
    image.image = model.image
  }
}
// MARK: - Setup

private extension OnboardingCell {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    addSubview(image)
    addSubview(topLabel)
    addSubview(bottomLabel)
  }
  
  func setConstraints() {
    image.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.7)
    }
    topLabel.snp.makeConstraints { make in
      make.top.equalTo(image.snp_bottomMargin).offset(20)
      make.left.right.equalToSuperview().inset(20)
    }
    bottomLabel.snp.makeConstraints { make in
      make.top.equalTo(topLabel.snp_bottomMargin).offset(20)
      make.left.right.equalToSuperview().inset(20)
    }
  }
}
