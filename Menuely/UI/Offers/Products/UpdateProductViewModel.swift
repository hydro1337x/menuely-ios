//
//  UpdateProductViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation
import Resolver
import UIKit

extension UpdateProductView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var productsService: ProductsServicing
        
        @Published var routing: UpdateProductView.Routing
        @Published var updateProductResult: Loadable<Discardable>
        @Published var name: String = ""
        @Published var description: String = ""
        @Published var price: String = ""
        @Published var image: UIImage?
        @Published var imageURL: String?
        
        @Published var isNameValid: Bool = false
        @Published var isDescriptionValid: Bool = false
        @Published var isPriceValid: Bool = false
        
        var isFormValid: Bool {
            return isNameValid && isDescriptionValid && isPriceValid
        }
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, updateProductResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.updateProduct])
            
            _updateProductResult = .init(initialValue: updateProductResult)
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.updateProduct] = $0 }
                
                appState
                    .map(\.routing.updateProduct)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func updateProduct() {
            guard !name.isEmpty,
                  !description.isEmpty,
                  let price = Float(self.price),
                  let productID = appState[\.routing.productsList.updateProduct]?.id else { return }
            
            var data: DataInfo?
            if let imageData = image?.jpegData(compressionQuality: 0.5) {
                data = DataInfo(mimeType: .jpeg, file: imageData, fieldName: "image")
            }
            
            let parameters = UpdateProductMultipartFormDataRequest.Parameters(name: name, description: description, price: price)
            let multipartFormDataRequest = UpdateProductMultipartFormDataRequest(data: data, parameters: parameters)
            productsService.updateProduct(with: productID, and: multipartFormDataRequest, updateProductResult: loadableSubject(\.updateProductResult))
        }
        
        func updateProductsListView() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.appState[\.data.updateProductsListView] = true
            }
        }
        
        func loadFields() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                guard let product = self.appState[\.routing.productsList.updateProduct] else { return }
                
                self.name =  product.name
                self.description = product.description
                self.price = product.price.description
                self.imageURL = product.image.url
            }
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.productsList.updateProduct] = nil
        }
    }
}
