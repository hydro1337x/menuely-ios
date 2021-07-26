//
//  FloatingTextField.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct FloatingTextField: View {
    @Binding private var text: String
    
    @State private var separatorColor: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    @State private var placeholderColor: Color
    @State private var placeholderOffset: CGFloat
    @State private var placeholderScale: CGFloat
     
    private let title: String
    
    init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
        if !text.wrappedValue.isEmpty {
            placeholderColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
            placeholderOffset = -25
            placeholderScale = 0.75
        } else {
            placeholderColor = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
            placeholderOffset = 0
            placeholderScale = 1
        }
    }
    
    var body: some View {
       ZStack(alignment: .leading) {
        GeometryReader { geometry in
                Text(title)
                    .font(.body)
                    .foregroundColor(placeholderColor)
                    .offset(y: placeholderOffset)
                    .scaleEffect(placeholderScale, anchor: .leading)
                
                TextField("", text: $text) { isActive in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        separatorColor = isActive ? Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)) : Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
                    }
                }
                .font(.body)
                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                .onChange(of: text, perform: { value in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        placeholderColor = value.isEmpty ? Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)) : Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                        placeholderOffset = value.isEmpty ? 0 : -25
                        placeholderScale = value.isEmpty ? 1 : 0.75
                    }
                })
                
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .foregroundColor(separatorColor )
                    .frame(width: geometry.size.width, height: 2, alignment: .center)
                    .offset(x: 0, y: 25)
            }
       }
       .padding(.top, 15)
   }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(text: .constant("Text"), title: "Title")
    }
}
