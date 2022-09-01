//
//  ViewModel-SignIn.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation
import Firebase

class SignInViewModel: ObservableObject {
  
  @Published var email: String = "chaves@gmail.com"
  @Published var password: String = "123123123"
  
  @Published var formInvalid = false  // bind pro alerta
  @Published var alertText = ""       // texto pro alerta
  @Published var isLoading = false    // bind pra progressView
  
  func signIn () {
    self.isLoading = true
    print("email: \(email), senha: \(password)")
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      guard let user = result?.user, error == nil else {
        self.formInvalid = true
        self.alertText = error!.localizedDescription
        print(error)
        self.isLoading = true
        return
      }
      self.isLoading = true
      print("usuario logado \(user.uid)")
    }
  }
}
