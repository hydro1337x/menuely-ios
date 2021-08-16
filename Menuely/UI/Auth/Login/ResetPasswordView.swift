//
//  ResetPasswordView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import SwiftUI
import Resolver

struct ResetPasswordView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                base
                dynamicContent
            }
            .navigationTitle("Reset password")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    @ViewBuilder
    private var base: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Enter the email associated with your account")
                .font(.body)
                .padding(.top, 25)
            
            FloatingTextField(text: $viewModel.email, title: "Email", validation: .email, isValid: $viewModel.isEmailValid)
                .frame(height: 48)
            
            Button(action: {
                viewModel.resetPassword()
            }, label: {
                Text("Reset")
            })
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            .disabled(!viewModel.isEmailValid)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.resetPasswordResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading Content

private extension ResetPasswordView {
    
    func loadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension ResetPasswordView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.alertView()
        return EmptyView()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
