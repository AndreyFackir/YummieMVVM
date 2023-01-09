//
//  ProfileViewModel.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 04.01.2023.
//

import Foundation
import Firebase

final class ProfileViewModel {
  weak var coordinator: MainScreenCoordinator?
  
  func logout() {
    do {
      try Auth.auth().signOut()
      coordinator?.goToAuth()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
  }
  
  
  func start(isOn: Bool) {
    print(isOn)
  }
}

