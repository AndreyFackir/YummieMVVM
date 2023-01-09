//
//  NotificationsView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 09.01.2023.
//

import UIKit

final class NotificationsView: UIView {
  
  
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
    element.image = UIImage(systemName: "bell.fill")
    element.tintColor = .specialPurple
    return element
  }()
  
  private let userAddressLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.text = "Notifications"
    element.font = .sanFranciscoMedium20
    return element
  }()
  
  private let notificationsSwitcher: UISwitch = {
    let element = UISwitch()
    element.isOn = false
    element.onTintColor = .specialPurple
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
}

// MARK: - Setup
private extension NotificationsView {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(locationPinImage)
    addSubview(userAddressLabel)
    addSubview(notificationsSwitcher)
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
    notificationsSwitcher.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.trailing.equalTo(snp_trailingMargin).inset(20)
    }
  }
}

