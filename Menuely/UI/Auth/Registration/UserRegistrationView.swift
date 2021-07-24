//
//  UserRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct UserRegistrationView: View {
    @InjectedObservedObject private var viewModel: UserRegistrationViewModel

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
            
            FloatingTextField(text: $viewModel.firstname, title: "Firstname")
                .frame(height: 48)
            
            FloatingTextField(text: $viewModel.lastname, title: "Lastname")
                .frame(height: 48)
            
            Button("Register") {
                viewModel.register()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            
            Button(action: {
                withAnimation {
                    viewModel.loginViewRoute()
                }
            }, label: {
                Text("Already registered?")
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
            })
            .padding(.top, 10)
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

// MARK: - Loading content

private extension UserRegistrationView {
    
    func loadingView() -> some View {
        return ActivityIndicatorView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension UserRegistrationView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.loginViewRoute()
        return EmptyView()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistrationView()
    }
}
