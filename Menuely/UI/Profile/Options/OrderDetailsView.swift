//
//  OrderDetailsView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.08.2021..
//

import SwiftUI
import Resolver

struct OrderDetailsView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            content
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("Order ID: \(viewModel.title)")
    }
}

private extension OrderDetailsView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.order {
        case .notRequested: notRequestedView
        case .isLoading(_, _):  loadingView()
        case .loaded(let order):  loadedView(order: order)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension OrderDetailsView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getOrder)
    }
    
    func loadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        viewModel.dismiss()
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension OrderDetailsView {
    func loadedView(order: Order) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return ScrollView {
            LazyVStack {
                ForEach(order.orderedProducts) { product in
                    ProductCell(title: product.name,
                                description: product.description,
                                buttonTitle: viewModel.format(price: product.price, currency: order.currency),
                                imageURL: product.imageUrl)
                }
            }
        }
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
