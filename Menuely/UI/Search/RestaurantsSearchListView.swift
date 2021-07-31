//
//  RestaurantsSearchListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import SwiftUI
import Resolver

struct RestaurantsSearchListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        listContent
    }
}

private extension RestaurantsSearchListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.restaurants {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let restaurants):  listLoadedView(restaurants, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantsSearchListView {
    var listNotRequestedView: some View {
        EmptyView()
    }
    
    func listLoadingView(_ previouslyLoaded: [Restaurant]?) -> some View {
        if let restaurants = previouslyLoaded {
            return AnyView(listLoadedView(restaurants, showLoading: true))
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

private extension RestaurantsSearchListView {
    func listLoadedView(_ restaurants: [Restaurant], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return ScrollView {
            LazyVStack {
                ForEach(restaurants) { restaurant in
                    SearchUsersCell(title: restaurant.name, description: restaurant.email, imageURL: URL(string: restaurant.profileImage?.url ?? ""))
                }
            }
        }
    }
}

struct RestaurantsSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsSearchListView()
    }
}
