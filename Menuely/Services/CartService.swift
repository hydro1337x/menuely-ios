//
//  CartService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.08.2021..
//

import Foundation

protocol CartServicing {
    func createCart(for restaurantID: Int, and tableID: Int)
    func deleteCart()
    func add(_ cartItem: CartItem)
    func remove(_ cartItem: CartItem)
    func decrementQuantity(for cartItem: CartItem)
}

class CartService: CartServicing {

    @Published private var cart: Cart!
    
    private var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    init(appState: Store<AppState>) {
        
        self.appState = appState
        
        cancelBag.collect {
            
            $cart
                .removeDuplicates()
                .sink { appState[\.data.cart] = $0 }
            
            appState
                .map(\.data.cart)
                .removeDuplicates()
                .assign(to: \.cart, on: self)
        }
    }
    
    func createCart(for restaurantID: Int, and tableID: Int) {
        self.cart = Cart(restaurantId: restaurantID, tableId: tableID)
    }
    
    func deleteCart() {
        cart = nil
    }
    
    func add(_ cartItem: CartItem) {
        if let index = cart.cartItems.firstIndex(where: { cartItem.id == $0.id }) {
            cart.cartItems[index].quantity += 1
            cart.cartItems[index].totalPrice = cart.cartItems[index].basePrice * Float(cart.cartItems[index].quantity)
        } else {
            cart.cartItems.append(cartItem)
        }
    }
    
    func remove(_ cartItem: CartItem) {
        guard let index = cart.cartItems.firstIndex(where: { $0.id == cartItem.id }) else { return }
        cart.cartItems.remove(at: index)
    }
    
    func decrementQuantity(for cartItem: CartItem) {
        guard let index = cart.cartItems.firstIndex(where: { $0.id == cartItem.id }) else { return }
        let cartItem = cart.cartItems[index]
        
        if cartItem.quantity > 1 {
            cart.cartItems[index].quantity -= 1
            cart.cartItems[index].totalPrice = cart.cartItems[index].basePrice * Float(cart.cartItems[index].quantity)
        }
    }
}
