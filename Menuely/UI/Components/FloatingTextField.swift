//
//  FloatingTextField.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct FloatingTextField: View {
    @Binding private var text: String
    @State private var isActive: Bool = false
    
    private let title: String
    
    init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }
    
    var body: some View {
           ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Text(title)
                    .foregroundColor($text.wrappedValue.isEmpty ? Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)) : Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)))
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                TextField("", text: $text) {
                    isActive = $0
                }
                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))

                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .foregroundColor($isActive.wrappedValue ? Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)) : Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .frame(width: geometry.size.width, height: 2, alignment: .center)
                    .offset(x: 0, y: 25)
            }
           }
           .padding(.top, 15)
           .animation(.spring(response: 0.3, dampingFraction: 0.5))
       }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(text: .constant("Text"), title: "Title")
    }
}
