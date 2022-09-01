//
//  ContactsView.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct ContactsView: View {
  
  @StateObject var viewModel = ContactsViewModel()
  
    var body: some View {
      VStack {
        if viewModel.isLoading {
          ProgressView()
        }
        List(viewModel.contacts, id: \.self) { contact in
          NavigationLink {
            ChatView(contact: contact)
          } label: {
            ContactRow(contact: contact)
          }

        }
      }.onAppear {
        viewModel.getContacts()
      }
      .navigationTitle("Contatos")
      .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactRow: View {
  
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
      Text(contact.name)
    }
  }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
