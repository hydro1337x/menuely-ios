//
//  RestaurantRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct RestaurantRegistrationView: View {
    @InjectedObservedObject private var viewModel: RestaurantRegistrationViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                Image(.restaurant)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom, 10)
                
                Group {
                    FloatingTextField(text: $viewModel.email, title: "Email")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.password, title: "Password")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.name, title: "Name")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.description, title: "Description")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.country, title: "Country")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.city, title: "City")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.address, title: "Address")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.postalCode, title: "Postal code")
                        .frame(height: 48)
                }
                
                Button("Register") {
                    print("Registered")
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
}

struct RestaurantRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRegistrationView()
    }
}
