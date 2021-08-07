//
//  CartView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import SwiftUI
import Resolver

struct CartView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            List(viewModel.cart!.cartItems) { cartItem in
                Text(cartItem.name)
            }
            .navigationBarTitle("Cart")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
