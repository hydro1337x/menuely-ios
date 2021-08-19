//
//  RestaurantOrdersListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 15.08.2021..
//

import SwiftUI
import Resolver

struct RestaurantOrdersListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        listContent
            .navigationBarTitle("Restaurant orders")
            .navigationBarItems(trailing: Button(action: {
                viewModel.getOrders()
            }, label: {
                Image(.refresh)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }))
    }
}

private extension RestaurantOrdersListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.orders {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let orders):  listLoadedView(orders, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantOrdersListView {
    var listNotRequestedView: some View {
        Text("").onAppear {
            self.viewModel.getOrders()
        }
    }
    
    func listLoadingView(_ previouslyLoaded: [Order]?) -> some View {
        if let orders = previouslyLoaded {
            return AnyView(listLoadedView(orders, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension RestaurantOrdersListView {
    func listLoadedView(_ orders: [Order], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return List {
            ForEach(orders) { order in
                NavigationLink(
                    destination: RestaurantOrderDetailsView(),
                    tag: order.id,
                    selection: $viewModel.routing.orderDetailsForId) {
                    OrderCell(title: order.customerName ?? "", subtitle: viewModel.timeIntervalToString(order.createdAt), price: viewModel.format(price: order.totalPrice, currency: order.currency), isActive: order.employeeName != nil ? false : true)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    }
                    .onTapGesture {
                        viewModel.routing.orderDetailsForId = order.id
                    }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

extension RestaurantOrdersListView {
    struct Routing: Equatable {
        var orderDetailsForId: Int?
    }
}

struct RestaurantOrdersListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantOrdersListView()
    }
}
