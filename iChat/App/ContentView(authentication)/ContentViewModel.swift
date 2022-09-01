//
//  ContentViewModel.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject {
  
  @Published var isLogged = Auth.auth().currentUser != nil
  
  func onAppear() {
    Auth.auth().addStateDidChangeListener { auth, user in
      self.isLogged = user != nil
    }
  }
  
}
