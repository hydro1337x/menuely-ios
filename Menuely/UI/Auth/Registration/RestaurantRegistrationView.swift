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
        ZStack {
            base
            dynamicContent
        }
    }
    
    private var base: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Group {
                    FloatingTextField(text: $viewModel.email, title: "Email")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.password, title: "Password")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.name, title: "Name")
                        .frame(height: 48)
                    
                    FloatingTextEditor(text: $viewModel.description, title: "Description")
                        .frame(height: 200)
                    
                    FloatingTextField(text: $viewModel.country, title: "Country")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.city, title: "City")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.address, title: "Address")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.postalCode, title: "Postal code")
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
