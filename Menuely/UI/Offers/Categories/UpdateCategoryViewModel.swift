//
//  UpdateCategoryViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation
import Resolver
import UIKit

class UpdateCategoryViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var categoriesService: CategoriesServicing
    
    @Published var routing: UpdateCategoryView.Routing
    @Published var updateCategoryResult: Loadable<Discardable>
    @Published var name: String = ""
    @Published var image: UIImage?
    @Published var imageURL: String?
    
    @Published var isNameValid: Bool = false
    var isFormValid: Bool {
        return isNameValid
    }
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateCategoryResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.updateCategory])
        
        _updateCategoryResult = .init(initialValue: updateCategoryResult)
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.updateCategory] = $0 }
            
            appState
                .map(\.routing.updateCategory)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    // MARK: - Methods
    func updateCategory() {
        guard !name.isEmpty,
              let imageData = image?.jpegData(compressionQuality: 0.5),
              let categoryID = appState[\.routing.categoriesList.updateCategory]?.id else { return }
        
        let data = DataInfo(mimeType: .jpeg, file: imageData, fieldName: "image")
        let parameters = UpdateCategoryMultipartFormDataRequest.Parameters(name: name)
        let multipartFormDataRequest = UpdateCategoryMultipartFormDataRequest(data: data, parameters: parameters)
        categoriesService.updateCategory(with: categoryID, and: multipartFormDataRequest, updateCategoryResult: loadableSubject(\.updateCategoryResult))
    }
    
    func updateCategoriesListView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.appState[\.data.updateCategoriesListView] = true
        }
    }
    
    func loadFields() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let category = self.appState[\.routing.categoriesList.updateCategory] else { return }
            
            self.name =  category.name
            self.imageURL = category.image.url
        }
    }
    
    // MARK: - Routing
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func dismiss() {
        appState[\.routing.categoriesList.updateCategory] = nil
    }
}
