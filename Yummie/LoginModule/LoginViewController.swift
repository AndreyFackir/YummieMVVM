//
//  LoginViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 12.12.2022.
//

import UIKit
import SnapKit
import Combine
import Firebase

final class LoginViewController: UIViewController {
  private var subscription: Set<AnyCancellable> = []
  private let viewModel = LoginViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindings()
  }
  
  // MARK: - Properties
  
  private let loginVCLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.text = "Login"
    element.font = .sanFranciscoMedium40
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
  
  private let signInButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Sign In", for: .normal)
    element.layer.cornerRadius = 20
    element.titleLabel?.font = .sanFranciscoMedium20
    element.tintColor = .white
    element.backgroundColor = .specialPurple
    element.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    return element
  }()
  
  private let registerLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .systemGray
    element.text = "Don't have an account?"
    return element
  }()
  
  private let registerButton: UIButton = {
    let element = UIButton(type: .system)
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Register", for: .normal)
    element.titleLabel?.font = .sanFranciscoLight20
    element.setTitleColor(.specialPurple, for: .normal)
    element.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    return element
  }()
  
  private var stackView = UIStackView()
  
  // MARK: - Methods
  @objc private func signInButtonTapped() {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
        let mainVC = HomeViewController()
        mainVC.modalPresentationStyle = .fullScreen
        self?.present(mainVC, animated: true, completion: nil)
      }
      
    }
  }
  
  @objc private func registerButtonTapped() {
    print("registerButtonTapped")
    let registrVC = RegisterViewController()
    registrVC.modalPresentationStyle = .fullScreen
    present(registrVC, animated: true, completion: nil)
  }
  
  func bindings() {
    
  }
}

// MARK: - Setup
private extension LoginViewController {
  func setup() {
    view.backgroundColor = .specialBackground
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    view.addSubview(loginVCLabel)
    view.addSubview(emailTextField)
    view.addSubview(passwordTextField)
    view.addSubview(signInButton)
    stackView = UIStackView(arrangedSubviews: [registerLabel, registerButton], axis: .horizontal, spacing: 10)
    view.addSubview(stackView)
  }
  
  func setConstraints() {
    loginVCLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(100)
      make.centerX.equalToSuperview()
    }
    emailTextField.snp.makeConstraints { make in
      make.top.equalTo(loginVCLabel.snp_bottomMargin).inset(-30)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp_bottomMargin).inset(-30)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    signInButton.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp_bottomMargin).inset(-50)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
    stackView.snp.makeConstraints { make in
      make.top.equalTo(signInButton.snp_bottomMargin).inset(-30)
      make.centerX.equalToSuperview()
    }
  }
}
