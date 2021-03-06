//
//  UserRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI
import Resolver

struct UserRegistrationView: View {
    @StateObject private var viewModel: UserRegistrationViewModel = Resolver.resolve()

    var body: some View {
        ZStack {
            base
            dynamicContent
        }
    }
    
    private var base: some View {
        VStack {
            
            FloatingTextField(text: $viewModel.email, title: "Email", validation: .email, isValid: $viewModel.isEmailValid)
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.password, title: "Password", type: .secure, validation: .lenght(6), isValid: $viewModel.isPasswordValid)
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.firstname, title: "Firstname", validation: .notEmpty, isValid: $viewModel.isFirstnameValid)
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.lastname, title: "Lastname", validation: .notEmpty, isValid: $viewModel.isLastnameValid)
                .frame(height: 48)
            
            Button("Register") {
                viewModel.register()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            .disabled(!viewModel.isFormValid)
            
            Button(action: {
                withAnimation {
                    viewModel.loginView()
                }
            }, label: {
                Text("Already registered?")
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            })
            .padding(.top, 10)
        }
        .padding(.horizontal, 16)
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

// MARK: - Loading content

private extension UserRegistrationView {
    
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

private extension UserRegistrationView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.loginView()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return EmptyView()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistrationView()
    }
}
