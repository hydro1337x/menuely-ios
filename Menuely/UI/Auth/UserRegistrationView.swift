//
//  UserRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct UserRegistrationView: View {
    @InjectedObservedObject private var viewModel: UserRegistrationViewModel
    
    var body: some View {
        VStack {
            
            Image(.person)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom, 10)
            
            FloatingTextField(text: $viewModel.email, title: "Email")
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.password, title: "Password")
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.firstname, title: "Firstname")
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.lastname, title: "Lastname")
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
        .padding(.horizontal, 30)
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistrationView()
    }
}
