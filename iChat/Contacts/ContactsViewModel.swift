//
//  ContactsViewModel.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation
import Firebase

class ContactsViewModel: ObservableObject {
  
  @Published var contacts: [Contact] = []
  @Published var isLoading = false
  
  var isLoaded = false
  
  func getContacts() {
    
    if isLoaded { return }
    
    self.isLoading = true
    self.isLoaded = true
    
    Firestore.firestore().collection("users")
      .getDocuments { querySnapshot, error in
        
        if let error = error {
          print("erro ao buscar contatos \(error)")
          return
        }
        
        for document in querySnapshot!.documents {
          if Auth.auth().currentUser!.uid != document.documentID {
            print("ID \(document.documentID) \(document.data())")
            self.contacts.append(Contact(uuid: document.documentID,
                                    name: document.data()["name"] as! String,
                                    profileUrl: document.data()["profileUrl"] as! String))
          }
        }
        self.isLoading = false
        
      }
  }
  
}
