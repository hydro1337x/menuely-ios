//
//  LoginView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI
import Resolver

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            base
            dynamicContent
        }
        .sheet(isPresented: viewModel.routing.isResetPasswordSheetPresented == true ? .constant(true) : .constant(false), onDismiss: {
            viewModel.routing.isResetPasswordSheetPresented = false
        }, content: {
            ResetPasswordView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
    }
    
    private var base: some View {
        VStack {
            FloatingTextField(text: $viewModel.email, title: "Email", validation: .email, isValid: $viewModel.isEmailValid)
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.password, title: "Password", type: .secure, validation: .lenght(6), isValid: $viewModel.isPasswordValid)
                .frame(height: 48)
            
            Button("Login") {
                viewModel.login()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            .disabled(!viewModel.isFormValid)
            
            Button(action: {
                withAnimation {
                    viewModel.registrationView()
                }
            }, label: {
                Text("Don't have an account?")
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            })
            .padding(.top, 10)
            
            Button(action: {
                viewModel.resetPasswordView()
            }, label: {
                Text("Reset password")
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            })
            .padding(.top, 10)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.loginResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading Content

private extension LoginView {
    
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

private extension LoginView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.tabBarView()
        return EmptyView()
    }
}

extension LoginView {
    struct Routing: Equatable {
        var isResetPasswordSheetPresented: Bool?
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
