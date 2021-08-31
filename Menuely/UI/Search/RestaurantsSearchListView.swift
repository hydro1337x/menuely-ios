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
            .fullScreenCover(isPresented: viewModel.routing.restaurantNoticeForInfo == nil ? .constant(false) : .constant(true), content: {
                RestaurantNoticeView()
                    .modifier(PopoversViewModifier())
                    .modifier(ActivityViewModifier())
            })
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
        
        return List {
            ForEach(restaurants) { restaurant in
                SearchCell(title: restaurant.name, imageURL: URL(string: restaurant.profileImage?.url ?? ""))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    .onTapGesture {
                        viewModel.restaurantNoticeView(for: restaurant)
                    }
            }
        }
        .listStyle(InsetGroupedListStyle())
        
    }
}

extension RestaurantsSearchListView {
    struct Routing: Equatable {
        var restaurantNoticeForInfo: RestaurantNoticeInfo?
    }
}

struct RestaurantsSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsSearchListView()
    }
}
