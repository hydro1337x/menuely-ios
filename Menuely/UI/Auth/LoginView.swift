//
//  LoginView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct LoginView: View {
    @InjectedObservedObject private var viewModel: LoginViewModel
    
    @State private var animateErrorView: Bool = false
    
    var body: some View {
        ZStack {
            base
            dynamicContent
        }
    }
    
    private var base: some View {
        VStack {
            FloatingTextField(text: $viewModel.email, title: "Email")
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.password, title: "Password")
                .frame(height: 48)
            
            Button("Login") {
                viewModel.login()
            }
            .scaledFont(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            
            Spacer()
        }
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
        return ActivityIndicatorView().padding()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(isAnimating: $animateErrorView, message: error.localizedDescription) {
            viewModel.animateErrorView = false
        }
        .onReceive(viewModel.$animateErrorView, perform: { value in
            animateErrorView = value
        })
    }
}

// MARK: - Displaying Content

private extension LoginView {
    func loadedView(showLoading: Bool) -> some View {
        EmptyView()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
