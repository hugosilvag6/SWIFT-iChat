//
//  ContentView.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModel = ContentViewModel()
  
    var body: some View {
      ZStack {
        if viewModel.isLogged {
          MessagesView()
        } else {
          SignInView()
        }
      }.onAppear {
        viewModel.onAppear()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
