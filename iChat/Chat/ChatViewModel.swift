//
//  ChatViewModel.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
  
  @Published var messages: [Message] = []
  @Published var text = ""
  
  var myName: String = ""
  var myPhoto: String = ""
  var limit = 20
  var inserting = false
  var newCount = 0
  
  func onAppear(contact: Contact) { // mostrará as mensagens no chat
    
    let fromId = Auth.auth().currentUser!.uid // eu
    
    Firestore.firestore().collection("users")
      .document(fromId)
      .getDocument { snapshot, error in
        if let error = error {
          print("Error fetching documents: \(error)")
          return
        }
        if let document = snapshot?.data() {
          self.myName = document["name"] as! String
          self.myPhoto = document["profileUrl"] as! String
        }
      }
    
    Firestore.firestore().collection("conversations") // acessar o banco de conversas
      .document(fromId) // acessar as minhas conversas
      .collection(contact.uuid) // acessar a conversa com fulano (toId)
      .order(by: "timestamp", descending: true)
      .start(after: [self.messages.last?.timestamp ?? 999999999999999999])
      .limit(to: limit)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error fetching documents: \(error)")
          return
        }
        if let changes = querySnapshot?.documentChanges { // fica escutando o tempo inteiro se o documento mudou
          for docChange in changes {
            if docChange.type == .added {
              let document = docChange.document
              print("Document is: \(document.documentID) \(document.data())")
              
              let message = Message(uuid: document.documentID,
                                    text: document.data()["text"] as! String,
                                    isMe: fromId == document.data()["fromId"] as! String,
                                    timestamp: document.data()["timestamp"] as! UInt)
              if self.inserting {
                self.messages.insert(message, at: 0)
              } else {
                self.messages.append(message)
              }
            }
          }
          self.inserting = false
        }
        self.newCount = self.messages.count
      }
    
  }
  
  func sendMessage (contact: Contact) {
    let text = self.text.trimmingCharacters(in: .whitespacesAndNewlines) // salva removendo espaço branco e novas linhas
    self.text = ""
    self.inserting = true
    self.newCount = self.newCount + 1
    
    let fromId = Auth.auth().currentUser!.uid // de quem
    let timestamp = Date().timeIntervalSince1970 // para ordenar as msg
    
    Firestore.firestore().collection("conversations") // coleção 1 (conversations)
      .document(fromId) // coleção 1 (conversations) > fromId
      .collection(contact.uuid) // coleção 1 (conversations) > fromId > coleção 2 (toId)
      .addDocument(data: [
        "text": text,
        "fromId": fromId,
        "toId": contact.uuid,
        "timestamp": UInt(timestamp)]) { err in
          if err != nil {
            print("Error: \(err!.localizedDescription)")
            return
          }
        }
    Firestore.firestore().collection("last-messages")
      .document(fromId)
      .collection("contacts")
      .document(contact.uuid)
      .setData([
        "uid": contact.uuid,
        "username": contact.name,
        "photoUrl": contact.profileUrl,
        "timestamp": UInt(timestamp),
        "lastMessage": text])
    
    // agora salvamos no outro usuario (o que recebe), pra ele também ter as msg quando abrir o app
    Firestore.firestore().collection("conversations")
      .document(contact.uuid)
      .collection(fromId)
      .addDocument(data: [
        "text": text,
        "fromId": fromId,
        "toId": contact.uuid,
        "timestamp": UInt(timestamp)]) { err in
          if err != nil {
            print("Error: \(err!.localizedDescription)")
            return
          }
        }
    Firestore.firestore().collection("last-messages")
      .document(contact.uuid)
      .collection("contacts")
      .document(fromId)
      .setData([
        "uid": fromId,
        "username": self.myName,
        "photoUrl": self.myPhoto,
        "timestamp": UInt(timestamp),
        "lastMessage": text])
    
  }
  
}
