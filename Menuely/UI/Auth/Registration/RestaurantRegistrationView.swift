//
//  RestaurantRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI
import Resolver

struct RestaurantRegistrationView: View {
    @StateObject private var viewModel: RestaurantRegistrationViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            base
            dynamicContent
        }
    }
    
    private var base: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Group {
                    FloatingTextField(text: $viewModel.email, title: "Email", type: .email, isValid: $viewModel.isEmailValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.password, title: "Password", type: .lenght(6), isValid: $viewModel.isPasswordValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.name, title: "Name", type: .lenght(1), isValid: $viewModel.isNameValid)
                        .frame(height: 48)
                    
                    FloatingTextEditor(text: $viewModel.description, title: "Description")
                        .frame(height: 200)
                    
                    FloatingTextField(text: $viewModel.country, title: "Country", type: .lenght(1), isValid: $viewModel.isCountryValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.city, title: "City", type: .lenght(1), isValid: $viewModel.isCityValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.address, title: "Address", type: .lenght(1), isValid: $viewModel.isAddressValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.postalCode, title: "Postal code", type: .lenght(1), isValid: $viewModel.isPostalCodeValid)
                        .frame(height: 48)
                }
                .padding(.horizontal, 16)
                
                Button("Register") {
                    viewModel.register()
                }
                .font(.body)
                .frame(height: 48)
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .buttonStyle(RoundedGradientButtonStyle())
                .disabled(!viewModel.isFormValid)
                
                Button(action: {
                    withAnimation {
                        viewModel.loginView()
                    }
                }, label: {
                    Text("Already registered?")
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                })
                .padding(.top, 10)
                .padding(.horizontal, 16)
            }
        }
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
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension RestaurantRegistrationView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.loginView()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return EmptyView()
    }
}

struct RestaurantRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRegistrationView()
    }
}
