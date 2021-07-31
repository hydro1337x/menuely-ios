//
//  UpdatePasswordView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 24.07.2021..
//

import SwiftUI
import Resolver

struct UpdatePasswordView: View {
    @StateObject private var viewModel: UpdatePasswordViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            staticContent
            dynamicContent
        }
        .navigationBarTitle("Change password")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var staticContent: some View {
        ScrollView {
            VStack {
                FloatingTextField(text: $viewModel.oldPassword, title: "Old password")
                    .frame(height: 48)
                    .padding(.top, 15)
                
                FloatingTextField(text: $viewModel.newPassword, title: "New password")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.repeatedNewPassword, title: "Repeated new password")
                    .frame(height: 48)
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
            
            Button("Save") {
                viewModel.updatePassword()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .buttonStyle(RoundedGradientButtonStyle())
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.updatePasswordResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading content

private extension UpdatePasswordView {
    
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

private extension UpdatePasswordView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateProfile()
        viewModel.appState[\.routing.options.details] = nil
        return EmptyView()
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordView()
    }
}
