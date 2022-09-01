//
//  MessagesView.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct MessagesView: View {
  
  @StateObject var viewModel = MessagesViewModel()
  
    var body: some View {
      
      NavigationView {
        VStack {
          
          if viewModel.isLoading {
            ProgressView()
          }
          List(viewModel.contacts, id: \.self) { contact in
            NavigationLink {
              ChatView(contact: contact)
            } label: {
              ContactMessageRow(contact: contact)
            }
          }
          
        }
        .onAppear {
          viewModel.getContacts()
        }
        .navigationTitle("Mensagens")
        .toolbar {
          ToolbarItem(id: "contacts",
                      placement: .navigationBarTrailing,
                      showsByDefault: true) {
            NavigationLink {
              ContactsView()
            } label: {
              Text("Contatos")
            }
          }
          ToolbarItem(id: "logout",
                      placement: .navigationBarTrailing,
                      showsByDefault: true) {
            Button {
              viewModel.logout()
            } label: {
              Text("Logout")
            }
          }
          
        }
      }

    }
}

struct ContactMessageRow: View {
  
  var contact: Contact
  
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: contact.profileUrl)) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: { // o que aparece enquanto a imagem n foi carregada
        ProgressView()
      }
      .frame(width: 50, height: 50)
      
      VStack (alignment: .leading) {
        Text(contact.name)
        if let msg = contact.lastMessage {
          Text(msg)
            .lineLimit(1)
        }
      }
      Spacer()
    }
    .onAppear {
      print("aaaaaaikdsjaijfijfdsjifd")
      print(contact)
      print(contact.lastMessage)
      print(contact.name)
    }
  }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
