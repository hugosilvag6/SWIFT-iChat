//
//  MessagesViewModel.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation
import Firebase

class MessagesViewModel: ObservableObject {
  
  @Published var isLoading = false
  @Published var contacts: [Contact] = []
  
  func getContacts() { // isso vai criar as messagesRows da MessagesView com base na coleção last-messages, afinal só é preciso mostrar lá conversas que existem, ou seja, que tem last-message
    let fromId = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("last-messages")
      .document(fromId)
      .collection("contacts")
      .addSnapshotListener { snapshot, error in
        if let changes = snapshot?.documentChanges {
          for doc in changes {
            if doc.type == .added {
              let document = doc.document
              self.contacts.removeAll()
              self.contacts.append(Contact(uuid: document.documentID,
                                           name: document.data()["username"] as! String,
                                           profileUrl: document.data()["photoUrl"] as! String,
                                           lastMessage: document.data()["lastMessage"] as! String,
                                           timestamp: document.data()["timestamp"] as! UInt))
            }
          }
        }
      }
  }
  
  func logout() {
    try? Auth.auth().signOut()
  }
  
}
