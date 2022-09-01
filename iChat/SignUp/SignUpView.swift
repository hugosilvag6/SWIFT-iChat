//
//  View-Signup.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct SignUpView: View {
  
  @ObservedObject var viewModel = SignUpViewModel()
  
  var body: some View {
    VStack {
      
      Button {
        viewModel.isShowingPhotoLibrary = true
      } label: {
        
        if viewModel.image.size.width > 0 {
          Image(uiImage: viewModel.image)
            .resizable()
            .scaledToFill()
            .frame(width: 130, height: 130)
            .clipShape(Circle())
            .overlay {
              Circle().stroke(Color("GreenColor"), lineWidth: 4)
                .shadow(radius: 7)
            }
        } else {
          Text("Foto")
            .frame(width: 130, height: 130)
            .padding()
            .background(Color("GreenColor"))
            .foregroundColor(.white)
            .cornerRadius(100)
        }
      }
      .padding(.bottom, 32)
      .sheet(isPresented: $viewModel.isShowingPhotoLibrary) {
        ImagePicker(selectedImage: $viewModel.image)
      }
      
      
      TextField("Entre com seu nome", text: $viewModel.name)
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
        viewModel.signUp()
      } label: {
        Text("Cadastrar")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color("GreenColor"))
          .foregroundColor(.white)
          .cornerRadius(24)
      }
      .alert(isPresented: $viewModel.formInvalid) {
        Alert(title: Text(viewModel.alertText))
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 32)
    .background(Color.init(red: 240/255, green: 231/255, blue: 210/255))
    .navigationTitle("Sign Up")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
