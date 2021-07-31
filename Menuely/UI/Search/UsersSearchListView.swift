//
//  UsersSearchListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import SwiftUI
import Resolver

struct UsersSearchListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        listContent
    }
}

private extension UsersSearchListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.users {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let users):  listLoadedView(users, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension UsersSearchListView {
    var listNotRequestedView: some View {
        EmptyView()
    }
    
    func listLoadingView(_ previouslyLoaded: [User]?) -> some View {
        if let users = previouslyLoaded {
            return AnyView(listLoadedView(users, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func operationLoadingView() -> some View {
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

private extension UsersSearchListView {
    func listLoadedView(_ users: [User], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    SearchUsersCell(title: user.name, description: user.email, imageURL: URL(string: user.profileImage?.url ?? ""))
                }
            }
        }
    }
}

struct SearchEmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        UsersSearchListView()
    }
}
