//
//  RestaurantRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct RestaurantRegistrationView: View {
    @InjectedObservedObject private var viewModel: RestaurantRegistrationViewModel
    
    @State private var animateErrorView: Bool = false
    
    var body: some View {
        ZStack {
            base
            dynamicContent
        }
    }
    
    private var base: some View {
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
                viewModel.register()
            }
            .scaledFont(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.registration {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading Content

private extension RestaurantRegistrationView {
    
    func loadingView() -> some View {
        return ActivityIndicatorView().padding()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(animate: $animateErrorView, message: error.localizedDescription) {
            viewModel.animateErrorView = false
        }
        .onReceive(viewModel.$animateErrorView, perform: { value in
            animateErrorView = value
        })
    }
}

// MARK: - Displaying Content

private extension RestaurantRegistrationView {
    func loadedView(showLoading: Bool) -> some View {
        ActivityIndicatorView().padding()
    }
}

struct RestaurantRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRegistrationView()
    }
}
