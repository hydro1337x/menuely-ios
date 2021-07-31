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
        
        @Published var routing: ProductsListView.Routing
        @Published var products: Loadable<[Product]>
        @Published var operationResult: Loadable<Discardable>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        var categoryImageURL: URL? {
            let urlString = appState[\.routing.categoriesList.productsForCategory]?.image.url
            return URL(string: urlString ?? "")
        }
        
        var title: String {
            return appState[\.routing.categoriesList.productsForCategory]?.name ?? ""
        }
        
        // MARK: - Initialization
        init(appState: Store<AppState>, products: Loadable<[Product]> = .notRequested, operationResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.productsList])
            _products = .init(initialValue: products)
            _operationResult = .init(initialValue: operationResult)
            
            cancelBag.collect {
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
            guard let category = appState[\.routing.categoriesList.productsForCategory] else { return }
            let queryRequestable = ProductsQueryRequest(categoryId: category.id)
            productsService.getProducts(with: queryRequestable, products: loadableSubject(\.products))
        }
        
        func deleteProduct(with id: Int) {
            productsService.deleteProduct(with: id, deleteProductResult: loadableSubject(\.operationResult))
        }
        
        func resetOperationsState() {
            operationResult.reset()
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
        
        func actionView(for product: Product, with additionalAction: @escaping () -> Void) {
            let delete = Action(name: "Delete") {
                self.appState[\.routing.action.configuration] = nil
                self.deletionAlertView(for: product)
            }
            
            let update = Action(name: "Edit") {
                self.appState[\.routing.action.configuration] = nil
                self.appState[\.routing.productsList.updateProduct] = product
            }
            
            let configuration = ActionViewConfiguration(title: "\(product.name) actions", actions: [update, delete]) {
                additionalAction()
                self.appState[\.routing.action.configuration] = nil
            }
            
            appState[\.routing.action.configuration] = configuration
        }
    }
}
