//
//  ProfileViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 04.01.2023.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
  var viewModel = ProfileViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Properties
  
  private let userFotoAndNameView = UserFotoAndNameView()
  private let addressView = AddressView()
  private let notificationsView = NotificationsView()
  
  
  
  private let logoutButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Logout", for: .normal)
    element.layer.cornerRadius = 20
    element.titleLabel?.font = .sanFranciscoMedium20
    element.tintColor = .white
    element.backgroundColor = .specialPurple
    element.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    return element
  }()
  
  // MARK: - Methods
  
  @objc private func logoutButtonTapped() {
    print("logoutButtonTapped")
    viewModel.logout()
  }
}

// MARK: - Setup

private extension ProfileViewController {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    title = "MY PROFILE"
    view.backgroundColor = .specialBackground
    view.addSubview(logoutButton)
    view.addSubview(userFotoAndNameView)
    view.addSubview(addressView)
    view.addSubview(notificationsView)
  }
  
  func setConstraints() {
    userFotoAndNameView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
      make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(100)
    }
    addressView.snp.makeConstraints { make in
      make.top.equalTo(userFotoAndNameView.snp_bottomMargin).inset(-20)
      make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(100)
    }
    notificationsView.snp.makeConstraints { make in
      make.top.equalTo(addressView.snp_bottomMargin).inset(-20)
      make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(100)
    }
    logoutButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(50)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
  }
}
