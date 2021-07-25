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
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            
            Button(action: {
                withAnimation {
                    viewModel.registrationView()
                }
            }, label: {
                Text("Don't have an account?")
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
            })
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
