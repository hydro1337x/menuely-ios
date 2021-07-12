//
//  UserRegistrationView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct UserRegistrationView: View {
    @InjectedObservedObject private var viewModel: UserRegistrationViewModel
    
    @State private var animateErrorView: Bool = false

    var body: some View {
        ZStack {
            base
            content
        }
    }
    
    private var content: AnyView {
        switch viewModel.registration {
        case .notRequested: return AnyView(notRequestedView)
        case .isLoading(_, _): return AnyView(loadingView())
        case .loaded(_): return AnyView(loadedView(showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
    
    private var base: some View {
        VStack {
            
            Image(.person)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom, 10)
            
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
            .scaledFont(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .buttonStyle(RoundedGradientButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
}

// MARK: - Loading content
private extension UserRegistrationView {
    var notRequestedView: some View {
        AnyView(EmptyView()
                    .foregroundColor(.clear))
    }
    
    func loadingView() -> some View {
        return AnyView(ActivityIndicatorView().padding())
    }
    
    func failedView(_ error: Error) -> some View {
        AnyView(ErrorView(animate: $animateErrorView, message: error.localizedDescription) {
            viewModel.animateErrorView = false
        }
        .onReceive(viewModel.$animateErrorView, perform: { value in
            animateErrorView = value
        }))
    }
}

// MARK: - Displaying Content

private extension UserRegistrationView {
    func loadedView(showLoading: Bool) -> some View {
        ActivityIndicatorView().padding()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistrationView()
    }
}
