//
//  CreateProductViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation
import Resolver
import UIKit

extension CreateProductView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var productsService: ProductsServicing
        
        @Published var routing: CreateProductView.Routing
        @Published var createProductResult: Loadable<Discardable>
        @Published var name: String = ""
        @Published var description: String = ""
        @Published var price: String = ""
        @Published var image: UIImage?
        
        @Published var isNameValid: Bool = false
        @Published var isDescriptionValid: Bool = false
        @Published var isPriceValid: Bool = false
        // Image/price validation
        var isFormValid: Bool {
            return isNameValid && isDescriptionValid && isPriceValid
        }
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, createProductResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.createProduct])
            
            _createProductResult = .init(initialValue: createProductResult)
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.createProduct] = $0 }
                
                appState
                    .map(\.routing.createProduct)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func createProduct() {
            guard !name.isEmpty,
                  !description.isEmpty,
                  let price = Float(self.price),
                  let imageData = image?.jpegData(compressionQuality: 0.5),
                  let categoryID = appState[\.routing.categoriesList.products]?.categoryID else { return }
            let data = DataInfo(mimeType: .jpeg, file: imageData, fieldName: "image")
            
            let parameters = CreateProductMultipartFormDataRequest.Parameters(name: name, description: description, price: price, categoryId: categoryID)
            let multipartFormDataRequest = CreateProductMultipartFormDataRequest(data: data, parameters: parameters)
            productsService.createProduct(with: multipartFormDataRequest, createProductResult: loadableSubject(\.createProductResult))
        }
        
        func resetStates() {
            createProductResult.reset()
        }
        
        func updateProductsListView() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.appState[\.data.updateProductsListView] = true
            }
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.productsList.isCreateProductSheetPresented] = false
        }
    }
}
