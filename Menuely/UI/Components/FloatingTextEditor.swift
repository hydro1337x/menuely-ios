//
//  FloatingTextEditor.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct FloatingTextEditor: View {
    @Binding private var text: String
    @Binding private var isValid: Bool
    
    @State private var separatorColor: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    @State private var placeholderColor: Color
    @State private var placeholderOffset: CGFloat
    @State private var placeholderScale: CGFloat
    @State private var topPadding: CGFloat
    @State private var titleWithMessage: String
    
    private let title: String
    
    init(text: Binding<String>, title: String, isValid: Binding<Bool>) {
        self._text = text
        self._isValid = isValid
        self.title = title
        self.titleWithMessage = title
        if !text.wrappedValue.isEmpty {
            placeholderColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
            placeholderOffset = -20
            placeholderScale = 0.75
            topPadding = 20
        } else {
            placeholderColor = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
            placeholderOffset = 8
            placeholderScale = 1
            topPadding = 0
        }
        
        UITextView.appearance().backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
         GeometryReader { geometry in
            Text(titleWithMessage)
                .font(.body)
                .foregroundColor(placeholderColor)
                .offset(x: 7, y: placeholderOffset)
                .scaleEffect(placeholderScale, anchor: .leading)
            
            TextEditor(text: $text)
                .font(.body)
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .onChange(of: text, perform: { value in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        placeholderColor = value.isEmpty ? Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)) : Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                        if !text.isEmpty {
                            placeholderColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                            separatorColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                            titleWithMessage = title
                            $isValid.wrappedValue = true
                        } else {
                            placeholderColor = Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1))
                            separatorColor = Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1))
                            titleWithMessage = title + " | " + "Can not be empty"
                            $isValid.wrappedValue = false
                        }
                        placeholderOffset = value.isEmpty ? 8 : -20
                        placeholderScale = value.isEmpty ? 1 : 0.75
                        topPadding = value.isEmpty ? 0 : 20
                    }
                })
         }
        }
        .padding(.top, topPadding)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)), lineWidth: 1))
    }
}

struct FloatingTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextEditor(text: .constant(""), title: "Title", isValid: .constant(true))
    }
}
