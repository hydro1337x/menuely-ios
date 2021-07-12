//
//  ContentView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.06.2021..
//

import SwiftUI

struct ContentView: View {
    
    @InjectedObservedObject private var viewModel: UsersListViewModel
    
    var body: some View {
        content
    }
    
    private var content: AnyView {
        switch viewModel.users {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last, _): return AnyView(loadingView(last))
        case let .loaded(users): return AnyView(loadedView(users, showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}

// MARK: - Loading Content

private extension ContentView {
    var notRequestedView: some View {
        Text("").onAppear(perform: self.viewModel.getUsers)
    }
    
    func loadingView(_ previouslyLoaded: [User]?) -> some View {
        if let users = previouslyLoaded {
            return AnyView(loadedView(users, showLoading: true))
        } else {
            return AnyView(ActivityIndicatorView())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(isAnimating: .constant(false), message: error.localizedDescription, action: {})
    }
}

// MARK: - Displaying Content

private extension ContentView {
    func loadedView(_ users: [User], showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            List(users) { user in
                Text(user.firstname)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
