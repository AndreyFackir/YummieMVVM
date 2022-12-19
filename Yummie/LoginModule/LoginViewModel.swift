//
//  LoginViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 12.12.2022.
//

import Foundation
import Combine

protocol LoginNavigationProtocol: AnyObject {
  func goToRegisterPage()
}

final class LoginViewModel {
  weak var navigation: LoginNavigationProtocol?
  @Published var email = ""
  @Published var password = ""
  private var subscription: Set<AnyCancellable> = []
  
  // MARK: - Methods
  func signIn(with email: String, password: String) {
    
  }
  
  func goToRegisterPage() {
    navigation?.goToRegisterPage()
  }
}
