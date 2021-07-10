//
//  AuthSelectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct AuthSelectionView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    
    var body: some View {
        VStack {
            Image(.logo)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.top, 10)
            FloatingTextField(text: $emailText, title: "Email")
                .padding(.horizontal, 30)
                .frame(height: 48)
            FloatingTextField(text: $passwordText, title: "Password")
                .padding(.horizontal, 30)
                .frame(height: 48)
            SelectionCardView(imageName: .person, text: "Private person")
            Spacer()
        }
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
