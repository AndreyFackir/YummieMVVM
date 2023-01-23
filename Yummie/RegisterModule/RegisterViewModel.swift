//
//  RegisterViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 19.12.2022.
//

import Foundation
import Firebase
import Combine

final class RegisterViewModel {
  weak var coordinator: AuthCoordinator?
  
  // MARK: - Methods
  
  func createUser(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
        self?.goToMain()
      }
    }
  }
  func goToLogin() {
    coordinator?.goToLogin()
  }
  
  func goToMain() {
    coordinator?.hasAuthorized.send(true)
    coordinator?.goToMain()
  }
}
