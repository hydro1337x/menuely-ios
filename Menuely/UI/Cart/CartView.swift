//
//  CartView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            Text("Cart")
                .navigationBarTitle("Cart")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
