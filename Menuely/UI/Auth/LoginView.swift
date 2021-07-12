//
//  LoginView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct LoginView: View {
    @InjectedObservedObject private var viewModel: LoginViewModel
    
    var body: some View {
        Image(.restaurant)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100, alignment: .center)
            .padding(.bottom, 10)
        
        FloatingTextField(text: $viewModel.email, title: "Email")
            .frame(height: 48)
        
        FloatingTextField(text: $viewModel.password, title: "Password")
            .frame(height: 48)
        
        Button("Login") {
            print("Logged in")
        }
        .scaledFont(.body)
        .frame(height: 48)
        .padding(.top, 20)
        .buttonStyle(RoundedGradientButtonStyle())
        
        Spacer()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
