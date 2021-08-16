//
//  RestaurantOrderDetailsView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import SwiftUI
import Resolver

struct RestaurantOrderDetailsView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            listContent
            acceptOrderResultContent
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.getOrder()
        }, label: {
            Image(.refresh)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
        }))
        .navigationBarTitle("Order ID: \(viewModel.title)")
    }
}

private extension RestaurantOrderDetailsView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.order {
        case .notRequested: notRequestedView
        case .isLoading(let last, _):  loadingView(last)
        case .loaded(let order):  listLoadedView(order, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
    
    @ViewBuilder
    private var acceptOrderResultContent: some View {
        switch viewModel.acceptOrderResult {
        case .notRequested: EmptyView()
        case .isLoading(_, _):  loadingView(nil)
        case .loaded(_):  acceptOrderResultLoadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantOrderDetailsView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getOrder)
    }
    
    func loadingView(_ previouslyLoaded: Order?) -> some View {
        if let order = previouslyLoaded {
            return AnyView(listLoadedView(order, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        viewModel.dismiss()
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension RestaurantOrderDetailsView {
    func listLoadedView(_ order: Order, showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
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
            
            Button(action: {
                viewModel.acceptOrder(with: order.id)
            }, label: {
                Text("Accept order")
            })
            .buttonStyle(RoundedGradientButtonStyle())
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func acceptOrderResultLoadedView() -> some View {
        viewModel.acceptOrderResult.reset()
        viewModel.getOrder()
        return EmptyView()
    }
}

struct RestaurantOrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantOrderDetailsView()
    }
}
