//
//  ChatView.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import SwiftUI

struct ChatView: View {
  
  @ObservedObject var viewModel = ChatViewModel()
  
  @State var textSize: CGSize = .zero // para crescer o input textEditor
  
  @Namespace var bottomId
  
  let contact: Contact
  
    var body: some View {
      VStack {
        
        ScrollViewReader { value in // serve pra mandar o scrollview pra algum lugar
          ScrollView(showsIndicators: false) {
            Color.clear
              .frame(height: 1)
              .id(bottomId) // esse é o novo lugar
            
            LazyVStack { // usamos uma lazy pq ela é disparada toda vez que precisa renderizar "mais conteúdo"
              ForEach(viewModel.messages, id: \.self) { message in
                MessageRow(message: message)
                  .scaleEffect(x: 1, y: -1, anchor: .center)
                  .onAppear {
                    if message == viewModel.messages.last && viewModel.messages.count >= viewModel.limit {
                      viewModel.onAppear(contact: contact)
                    }
                  }
              }
              .onChange(of: viewModel.newCount) { newValue in // definimos que ele deve buscar esse "novo lugar" sempre que hovuer mudanças em algo
                print("count is \(newValue)")
                if newValue > viewModel.messages.count {
                  withAnimation {
                    value.scrollTo(bottomId) // definimos onde é esse "novo lugar"
                  }
                }
              }
              .padding(.horizontal, 20)
            }
            
          }
          .gesture(DragGesture().onChanged({ _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          })) // para esconder o teclado quando scrolla
          .rotationEffect(Angle(degrees: 180)) // invertemos a tela pq a consulta no firebase vem um array da msg mais antia pra mais nova, e queremos mostrar da mais nova pra mais antiga
          .scaleEffect(x: -1, y: 1, anchor: .center) // invertemos por causa da consulta invertida
        }
        
        Spacer()
        
        HStack {
          
          ZStack { // envelopamos pra criar um text e crescer o input textEditor
            TextEditor(text: $viewModel.text)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
              .padding()
              .background(.white)
              .cornerRadius(24)
              .overlay {
                RoundedRectangle(cornerRadius: 24)
                  .stroke(Color(UIColor.separator), lineWidth: 1)
              }
              .frame(maxHeight: (textSize.height + 38) > 100 ? 100 : textSize.height + 38)
            Text(viewModel.text)
              .opacity(0)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(ViewGeometry())
              .lineLimit(4)
              .multilineTextAlignment(.leading)
              .padding(.horizontal, 21)
              .onPreferenceChange(ViewSizeKey.self) { size in
                print("textsize is \(size)")
                textSize = size
              }
          }
          
          Button {
            viewModel.sendMessage(contact: contact)
          } label: {
            Text("Enviar")
              .padding(.horizontal, 20)
              .padding(.vertical, 8)
              .background(Color("GreenColor"))
              .foregroundColor(.white)
              .cornerRadius(24)
          }
          .disabled(viewModel.text.isEmpty)

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        
      }
      .navigationTitle(contact.name)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        viewModel.onAppear(contact: contact)
      }
    }
}

struct MessageRow: View {
  let message: Message
  var body: some View {
    VStack(alignment: .leading) {
      Text(message.text)
        .padding(.vertical, 5)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 10)
        .background{
          RoundedRectangle(cornerRadius: 10)
            .fill(message.isMe ? Color(white: 0.95) : Color("GreenLightColor"))
        }
        .frame(maxWidth: 260, alignment: message.isMe ? .trailing : .leading)
    }
    .padding(.horizontal, 2)
    .frame(maxWidth: .infinity, alignment: message.isMe ? .trailing : .leading)
  }
}

// para crescer o input textEditor
struct ViewGeometry: View {
  var body: some View {
    GeometryReader { geometry in
      Color.clear
        .preference(key: ViewSizeKey.self, value: geometry.size)
    }
  }
}
// para crescer o input textEditor
struct ViewSizeKey: PreferenceKey {
  
  static var defaultValue: CGSize = .zero
  
  static func reduce(value: inout Value, nextValue: () -> Value) {
    print("new value is \(value)")
    value = nextValue()
  }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
      ChatView(contact: Contact(uuid: UUID().uuidString, name: "joao", profileUrl: ""))
    }
}
