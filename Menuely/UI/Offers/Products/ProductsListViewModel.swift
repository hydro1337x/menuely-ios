//
//  ProductsListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation
import Resolver

extension ProductsListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var productsService: ProductsServicing
        @Injected private var cartService: CartServicing
        
        @Published var cart: Cart?
        @Published var routing: ProductsListView.Routing
        @Published var products: Loadable<[Product]>
        @Published var operationResult: Loadable<Discardable>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        var categoryImageURL: URL? {
            let urlString = appState[\.routing.categoriesList.products]?.imageURL
            return URL(string: urlString ?? "")
        }
        
        var title: String {
            return appState[\.routing.categoriesList.products]?.categoryName ?? ""
        }
        
        var interactionType: OffersInteractionType {
            return appState[\.routing.categoriesList.products]?.interaction ?? .viewing
        }
        
        // MARK: - Initialization
        init(appState: Store<AppState>, products: Loadable<[Product]> = .notRequested, operationResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _cart = .init(initialValue: appState[\.data.cart])
            _routing = .init(initialValue: appState[\.routing.productsList])
            _products = .init(initialValue: products)
            _operationResult = .init(initialValue: operationResult)
            
            cancelBag.collect {
                appState
                    .map(\.data.cart)
                    .removeDuplicates()
                    .assign(to: \.cart, on: self)
                
                appState
                    .map(\.data.updateProductsListView)
                    .removeDuplicates()
                    .sink { shouldUpdateProductsListView in
                        if shouldUpdateProductsListView {
                            appState[\.data.updateProductsListView] = false
                            self.getProducts()
                        }
                    }
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.productsList] = $0 }
                
                appState
                    .map(\.routing.productsList)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
                    
            }
        }
        
        // MARK: - Methods
        func getProducts() {
            guard let id = appState[\.routing.categoriesList.products]?.categoryID else { return }
            let queryRequestable = ProductsQueryRequest(categoryId: id)
            productsService.getProducts(with: queryRequestable, products: loadableSubject(\.products))
        }
        
        func deleteProduct(with id: Int) {
            productsService.deleteProduct(with: id, deleteProductResult: loadableSubject(\.operationResult))
        }
        
        func resetOperationsState() {
            operationResult.reset()
        }
        
        func addCartItem(_ product: Product) {
            cartService.add(CartItem(with: product))
        }
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func deletionAlertView(for product: Product) {
            let configuration = AlertViewConfiguration(title: "Delete product", message: "Are you sure you want to delete \(product.id)", primaryAction: {
                self.appState[\.routing.alert.configuration] = nil
                self.deleteProduct(with: product.id)
            }, primaryButtonTitle: "Delete", secondaryAction: {
                self.appState[\.routing.alert.configuration] = nil
            }, secondaryButtonTitle: "Cancel")
            appState[\.routing.alert.configuration] = configuration
        }
        
        func updateProductView(with product: Product) {
            appState[\.routing.productsList.updateProduct] = product
        }
    }
}
