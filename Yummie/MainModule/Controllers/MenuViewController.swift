//
//  MenuViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 23.01.2023.
//

import UIKit
import SnapKit


enum MenuOptions: String, CaseIterable {
  case home = "Home"
  case info = "Information"
  case settings = "Settings"
  case shareApp = "Share App"
  
  var imageName: String {
    switch self {
      case .home:
        return "house"
      case .settings:
        return "person.circle"
      case .info:
        return "info.circle"
      case .shareApp:
        return "square.and.arrow.up"
    }
  }
}

final class MenuViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Properties
  
  private let tableView: UITableView = {
    let element = UITableView()
    element.backgroundColor = .darkGray
    element.isScrollEnabled = false
    return element
  }()
  
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
  }
}

// MARK: -  Setup
private extension MenuViewController {
  private func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    view.backgroundColor = .darkGray
    view.addSubview(logoutButton)
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menu")
    
  }
  
  func setConstraints() {
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(logoutButton.snp_topMargin).inset(-30)
      make.left.right.equalToSuperview()
    }
    logoutButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(50)
      make.width.equalTo(view.snp.width).multipliedBy(0.5)
      make.leading.equalTo(view.snp_leadingMargin).inset(40)
      make.height.equalTo(60)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension MenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MenuOptions.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
    cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
    cell.textLabel?.textColor = .white
    cell.backgroundColor = .darkGray
    cell.contentView.backgroundColor = .darkGray
    cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
    cell.imageView?.tintColor = .white
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension MenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = MenuOptions.allCases[indexPath.row]
  }
  
}
