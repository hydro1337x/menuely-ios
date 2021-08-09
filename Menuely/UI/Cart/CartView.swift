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
        List {
            ForEach(viewModel.cart!.cartItems) { cartItem in
                CartCell(imageURL: URL(string: cartItem.imageURL), title: cartItem.name, price: viewModel.format(price: cartItem.totalPrice, currency: cartItem.currency), quantity: cartItem.quantity.description, incrementAction: {
                    viewModel.incrementQuantity(for: cartItem)
                }, decrementAction: {
                    viewModel.decrementQuantity(for: cartItem)
                })
                .onLongPressGesture {
                    viewModel.actionView(for: cartItem) {
                        presentation.wrappedValue.dismiss()
                    } and: {
                        isLongPressed = false
                    }
                    isLongPressed = true
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
            DetailCell(title: "Table", text: viewModel.cart?.tableId.description ?? "")
            DetailCell(title: "Total", text: viewModel.format(price: viewModel.cart?.totalPrice ?? 0, currency: viewModel.cart?.cartItems.first?.currency ?? ""))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Cart")
        .navigationBarTitleDisplayMode(.large)
        
        Button(action: {}, label: {
            Text("Place order")
        })
        .frame(height: 48)
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .buttonStyle(RoundedGradientButtonStyle())
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
