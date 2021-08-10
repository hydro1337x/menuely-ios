//
//  CreateCategoryViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation
import Resolver
import UIKit

class CreateCategoryViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var categoriesService: CategoriesServicing
    
    @Published var routing: CreateCategoryView.Routing
    @Published var createCategoryResult: Loadable<Discardable>
    @Published var name: String = ""
    @Published var image: UIImage?
    
    @Published var isNameValid: Bool = false
    var isFormValid: Bool {
        return isNameValid && image != nil
    }
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, createCategoryResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.createCategory])
        
        _createCategoryResult = .init(initialValue: createCategoryResult)
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.createCategory] = $0 }
            
            appState
                .map(\.routing.createCategory)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    // MARK: - Methods
    func createCategory() {
        guard !name.isEmpty,
              let imageData = image?.jpegData(compressionQuality: 0.5),
              let menuID = appState[\.routing.menusList.categories]?.menuID else { return }
        let data = DataInfo(mimeType: .jpeg, file: imageData, fieldName: "image")
        
        let parameters = CreateCategoryMultipartFormDataRequest.Parameters(name: name, menuId: menuID)
        let multipartFormDataRequest = CreateCategoryMultipartFormDataRequest(data: data, parameters: parameters)
        categoriesService.createCategory(with: multipartFormDataRequest, createCategoryResult: loadableSubject(\.createCategoryResult))
    }
    
    func resetStates() {
        createCategoryResult.reset()
    }
    
    func updateCategoriesListView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.appState[\.data.updateCategoriesListView] = true
        }
    }
    
    // MARK: - Routing
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func dismiss() {
        appState[\.routing.categoriesList.isCreateCategorySheetPresented] = false
    }
}
