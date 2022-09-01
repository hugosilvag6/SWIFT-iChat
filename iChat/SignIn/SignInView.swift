//
//  ContentView.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct SignInView: View {
  
  @ObservedObject var viewModel = SignInViewModel()
  
    var body: some View {
      NavigationView {
        VStack {
          
          Image("chat_logo")
            .resizable()
            .scaledToFit()
            .padding()
          
          TextField("Entre com seu email", text: $viewModel.email)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(false)
            .padding()
            .background(.white)
            .cornerRadius(24)
            .overlay {
              RoundedRectangle(cornerRadius: 24)
                .stroke(Color(UIColor.separator), lineWidth: 1)
            }
            .padding(.bottom, 20)
            .foregroundColor(.black)
          
          SecureField("Entre com sua senha", text: $viewModel.password)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(false)
            .padding()
            .background(.white)
            .cornerRadius(24)
            .overlay {
              RoundedRectangle(cornerRadius: 24)
                .stroke(Color(UIColor.separator), lineWidth: 1)
            }
            .padding(.bottom, 30)
            .foregroundColor(.black)
          
          if viewModel.isLoading {
            ProgressView()
              .padding()
          }
          
          Button {
            viewModel.signIn()
          } label: {
            Text("Entrar")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color("GreenColor"))
              .foregroundColor(.white)
              .cornerRadius(24)
          }
          .alert(isPresented: $viewModel.formInvalid) {
            Alert(title: Text(viewModel.alertText))
          }
          
          Divider()
            .padding()
          
          NavigationLink {
            SignUpView()
          } label: {
            Text("Não tem uma conta? Clique aqui")
              .foregroundColor(.black)
          }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color.init(red: 240/255, green: 231/255, blue: 210/255))
        .navigationTitle("Login")
        .navigationBarHidden(true)
      }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
      SignInView()
    }
}
