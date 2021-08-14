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
        return List {
            ForEach(order.orderedProducts) { product in
                OrderPreviewCell(imageURL: URL(string: product.imageUrl),
                                 title: product.name,
                                 price: viewModel.format(price: product.price, currency: order.currency),
                                 quantity: product.quantity.description)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
            
            Section(header: Text("Order info")) {
                DetailCell(title: "Restaurant", text: order.employerName ?? "-")
                DetailCell(title: "Waitperson", text: order.employeeName ?? "Not yet assigned")
                DetailCell(title: "Table", text: order.tableId.description)
                DetailCell(title: "Total price", text: viewModel.format(price: order.totalPrice, currency: order.currency))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
