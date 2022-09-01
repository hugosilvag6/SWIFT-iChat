//
//  ViewModel-SignUp.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

class SignUpViewModel: ObservableObject {
  
  @Published var email: String = "chaves@gmail.com"
  @Published var password: String = "123123123"
  @Published var name: String = ""
  @Published var image = UIImage()
  
  @Published var formInvalid = false  // bind pro alerta
  @Published var alertText = ""       // texto pro alerta
  @Published var isLoading = false    // bind pra progressView
  @Published var isShowingPhotoLibrary = false // bind pra sheet que mostra a galeria
  
  func signUp () {
    print("email: \(email), senha: \(password), name: \(name)")
    
    if image.size.width <= 1 {
      formInvalid = true
      alertText = "Selecione uma foto"
      return
    }

    self.isLoading = true
    
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      guard let user = result?.user, error == nil else {
        self.formInvalid = true
        self.alertText = error!.localizedDescription
        print(error)
        self.isLoading = true
        return
      }
      self.isLoading = true
      print("usuario criado \(user.uid)")
      
      self.uploadPhoto()
    }
  }
  
  private func uploadPhoto () {
    let filename = UUID().uuidString
    
    // criar objeto data binario 010101
    guard let data = image.jpegData(compressionQuality: 0.2) else { return }
    // dizer o formato da foto
    let newMetadata = StorageMetadata()
    newMetadata.contentType = "image/jpeg"
    // referencia no Storage (onde a foto será armazenada)
    let ref = Storage.storage().reference(withPath: "/images/\(filename).jpg")
    
    // mandar a foto
    ref.putData(data, metadata: newMetadata) { metadata, err in
      // vamos pegar a url de download pra por no console
      ref.downloadURL { url, error in
        self.isLoading = false
        guard let url = url else { return }
        print("foto criada \(url)")
        self.createUser(photoUrl: url)
      }
    }
  }
  
  private func createUser(photoUrl: URL) {
    
    let id = Auth.auth().currentUser!.uid
    
    Firestore.firestore().collection("users") // vai ser na coleção users
      .document(id) // criamos um documento sem id (usa o id automatico do firestore)
      .setData([
        "name": name,
        "uuid": id,
        "profileUrl": photoUrl.absoluteString // pega a url toda, absoluta
      ]) { err in
        self.isLoading = false
        if err != nil {
          print(err!.localizedDescription)
          return
        }
      }
  }
}
