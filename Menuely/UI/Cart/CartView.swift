//
//  CartView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import SwiftUI
import Resolver

struct CartView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    @State private var isLongPressed: Bool = false
    
    var body: some View {
        ZStack {
            listContent
            dynamicContent
        }
        .navigationBarTitle("Cart")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    var listContent: some View {
        VStack {
            List {
                if let cart = viewModel.cart {
                    ForEach(cart.cartItems) { cartItem in
                        CartCell(imageURL: URL(string: cartItem.imageURL), title: cartItem.name, price: viewModel.format(price: cartItem.totalPrice, currency: cartItem.currency), quantity: cartItem.quantity.description, incrementAction: {
                            viewModel.incrementQuantity(for: cartItem)
                        }, decrementAction: {
                            viewModel.decrementQuantity(for: cartItem)
                        })
                        .contextMenu(menuItems: {
                            Button(action: {
                                viewModel.deletionAlertView(for: cartItem, with: {
                                    presentation.wrappedValue.dismiss()
                                })
                            }, label: {
                                Text("Delete")
                            })
                        })
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    }
                    DetailCell(title: "Table", text: viewModel.cart?.tableId.description ?? "")
                    DetailCell(title: "Total", text: viewModel.format(price: viewModel.cart?.totalPrice ?? 0, currency: viewModel.cart?.cartItems.first?.currency ?? ""))
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Button(action: {
                viewModel.createOrder()
            }, label: {
                Text("Place order")
            })
            .frame(height: 48)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .buttonStyle(RoundedGradientButtonStyle())
        }
    }
}

private extension CartView {
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.createOrderResult {
        case .notRequested: notRequestedView
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension CartView {
    var notRequestedView: some View {
        EmptyView()
    }
    
    func loadingView() -> some View {
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

private extension CartView {
    func loadedView() -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.alertView()
        return EmptyView()
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
