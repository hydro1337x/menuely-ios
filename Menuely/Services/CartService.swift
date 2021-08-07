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
    func removeCartItem(with id: Int)
    func decrementCartItem(with id: Int)
}

class CartService: CartServicing {

    @Published private var cart: Cart?
    
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
        if let index = cart?.cartItems.firstIndex(where: { cartItem.id == $0.id }) {
            cart?.cartItems[index].quantity += 1
        } else {
            cart?.cartItems.append(cartItem)
        }
    }
    
    func removeCartItem(with id: Int) {
        guard let index = cart?.cartItems.firstIndex(where: { $0.id == id }) else { return }
        cart?.cartItems.remove(at: index)
    }
    
    func decrementCartItem(with id: Int) {
        guard let index = cart?.cartItems.firstIndex(where: { $0.id == id }),
              let cartItem = cart?.cartItems[index] else { return }
        
        if cartItem.quantity > 1 {
            cart?.cartItems[index].quantity -= 1
        } else {
            cart?.cartItems.remove(at: index)
        }
    }
}
