//
//  UserFotoAndNameView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 09.01.2023.
//

import UIKit

final class UserFotoAndNameView: UIView {

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  private let userImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.image = UIImage(systemName: "plus.app")
    element.tintColor = .specialPurple
    return element
  }()
  
  private let userNameLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.text = "Sidney Crosby"
    element.font = .sanFranciscoMedium20
    return element
  }()
}

// MARK: - Setup
private extension UserFotoAndNameView {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(userImage)
    addSubview(userNameLabel)
    backgroundColor = .white
    layer.cornerRadius = 10

  }
  
  func setConstraints() {
    userImage.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.leading.equalTo(snp_leadingMargin).inset(20)
      make.width.height.equalTo(50)
    }
    userNameLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.leading.equalTo(userImage.snp_trailingMargin).inset(-50)
    }
  }
}
