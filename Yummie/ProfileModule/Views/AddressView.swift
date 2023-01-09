//
//  AddressView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 09.01.2023.
//

import UIKit

final class AddressView: UIView {

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  private let locationPinImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.image = UIImage(systemName: "mappin")
    element.tintColor = .specialPurple
    return element
  }()
  
  private let userAddressLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.text = "New York"
    element.font = .sanFranciscoMedium20
    return element
  }()
}

// MARK: - Setup
private extension AddressView {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(locationPinImage)
    addSubview(userAddressLabel)
    backgroundColor = .white
    layer.cornerRadius = 10
  }
  
  func setConstraints() {
    locationPinImage.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.leading.equalTo(snp_leadingMargin).inset(20)
      make.width.height.equalTo(50)
    }
    userAddressLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.leading.equalTo(locationPinImage.snp_trailingMargin).inset(-50)
    }
  }
}
