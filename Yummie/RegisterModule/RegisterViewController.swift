//
//  RegisterViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 12.12.2022.
//

import UIKit
import Combine
import Firebase

final class RegisterViewController: UIViewController {
  private var subscription: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindings()
  }
  
  // MARK: - Properties
  
  private let createAccountLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.text = "Create Account"
    element.font = .sanFranciscoMedium40
    return element
  }()
  
  private let fullNameTextField: UITextField = {
    let element = UITextField()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.clearButtonMode = .always
    element.layer.cornerRadius = 20
    element.font = .sanFranciscoMedium20
    element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: element.frame.height))
    element.leftViewMode = .always
    element.returnKeyType = .done
    element.placeholder = "First name Last name"
    element.backgroundColor = .white
    return element
  }()
  
  private let emailTextField: UITextField = {
    let element = UITextField()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.clearButtonMode = .always
    element.layer.cornerRadius = 20
    element.font = .sanFranciscoMedium20
    element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: element.frame.height))
    element.leftViewMode = .always
    element.returnKeyType = .done
    element.placeholder = "Email"
    element.backgroundColor = .white
    return element
  }()
  
  private let passwordTextField: UITextField = {
    let element = UITextField()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.clearButtonMode = .always
    element.layer.cornerRadius = 20
    element.font = .sanFranciscoMedium20
    element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: element.frame.height))
    element.leftViewMode = .always
    element.returnKeyType = .done
    element.placeholder = "Password"
    element.isSecureTextEntry = true
    element.backgroundColor = .white
    return element
  }()
  
  private let registerButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Register", for: .normal)
    element.layer.cornerRadius = 20
    element.titleLabel?.font = .sanFranciscoMedium20
    element.tintColor = .white
    element.backgroundColor = .specialPurple
    element.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    return element
  }()
  
  private let haveAcountLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .systemGray
    element.text = "Already have an account?"
    return element
  }()
  
  private let loginButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Login", for: .normal)
    element.titleLabel?.font = .sanFranciscoLight20
    element.setTitleColor(.specialPurple, for: .normal)
    element.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    return element
  }()
  
  private var stackView = UIStackView()
  
  // MARK: - Methods
  @objc private func registerButtonTapped() {
    print("signInButtonTapped")
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
        let mainVC = HomeViewController()
        mainVC.modalPresentationStyle = .fullScreen
        self?.show(mainVC, sender: self)
      }
    }
  }
  
  @objc private func loginButtonTapped() {
    print("registerButtonTapped")
    let loginVC = LoginViewController()
    loginVC.modalPresentationStyle = .fullScreen
    show(loginVC, sender: self)
  }
  
  func bindings() {
    print("A")
  }
}

// MARK: - Setup
private extension RegisterViewController {
  func setup() {
    view.backgroundColor = .specialBackground
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    view.addSubview(createAccountLabel)
    view.addSubview(emailTextField)
    view.addSubview(passwordTextField)
    view.addSubview(registerButton)
    view.addSubview(fullNameTextField)
    stackView = UIStackView(arrangedSubviews: [haveAcountLabel, loginButton], axis: .horizontal, spacing: 10)
    view.addSubview(stackView)
  }
  
  func setConstraints() {
    createAccountLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(100)
      make.centerX.equalToSuperview()
    }
    fullNameTextField.snp.makeConstraints { make in
      make.top.equalTo(createAccountLabel.snp_bottomMargin).inset(-30)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    emailTextField.snp.makeConstraints { make in
      make.top.equalTo(fullNameTextField.snp_bottomMargin).inset(-30)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp_bottomMargin).inset(-30)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    registerButton.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp_bottomMargin).inset(-50)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    stackView.snp.makeConstraints { make in
      make.top.equalTo(registerButton.snp_bottomMargin).inset(-30)
      make.centerX.equalToSuperview()
    }
  }
}



