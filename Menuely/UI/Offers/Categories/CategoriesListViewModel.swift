//
//  CategoriesListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation
import Resolver

class CategoriesListViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var categoriesService: CategoriesServicing
    
    @Published var cart: Cart?
    @Published var routing: CategoriesListView.Routing
    @Published var categories: Loadable<[Category]>
    @Published var operationResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    var title: String {
        return appState[\.routing.menusList.categories]?.menuName ?? appState[\.routing.restaurantNotice.categories]?.menuName ?? "Categories"
    }
    
    var interactionType: OffersInteractionType {
        return appState[\.routing.menusList.categories]?.interaction ?? appState[\.routing.restaurantNotice.categories]?.interaction ?? .viewing
    }
    
    // MARK: - Initialization
    init(appState: Store<AppState>, categories: Loadable<[Category]> = .notRequested, operationResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _cart = .init(initialValue: appState[\.data.cart])
        _routing = .init(initialValue: appState[\.routing.categoriesList])
        _categories = .init(initialValue: categories)
        _operationResult = .init(initialValue: operationResult)
        
        cancelBag.collect {
            appState
                .map(\.data.cart)
                .removeDuplicates()
                .assign(to: \.cart, on: self)
            
            appState
                .map(\.data.updateCategoriesListView)
                .removeDuplicates()
                .sink { shouldUpdateCategoriesListView in
                    if shouldUpdateCategoriesListView {
                        appState[\.data.updateCategoriesListView] = false
                        self.getCategories()
                    }
                }
            
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.categoriesList] = $0 }
            
            appState
                .map(\.routing.categoriesList)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
                
        }
    }
    
    // MARK: - Methods
    func getCategories() {
        guard let id = appState[\.routing.menusList.categories]?.menuID ?? appState[\.routing.restaurantNotice.categories]?.menuID else { return }
        let queryRequestable = CategoriesQueryRequest(menuId: id)
        categoriesService.getCategories(with: queryRequestable, categories: loadableSubject(\.categories))
    }
    
    func deleteCategory(with id: Int) {
        categoriesService.deleteCategory(with: id, deleteCategoryResult: loadableSubject(\.operationResult))
    }
    
    func resetOperationsState() {
        operationResult.reset()
    }
    
    // MARK: - Routing
    func productsListView(for category: Category) {
        routing.products = ProductsListDisplayInfo(categoryID: category.id, categoryName: category.name, imageURL: category.image.url, interaction: interactionType)
    }
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func deletionAlertView(for category: Category) {
        let configuration = AlertViewConfiguration(title: "Delete category", message: "Are you sure you want to delete \(category.id)", primaryAction: {
            self.appState[\.routing.alert.configuration] = nil
            self.deleteCategory(with: category.id)
        }, primaryButtonTitle: "Delete", secondaryAction: {
            self.appState[\.routing.alert.configuration] = nil
        }, secondaryButtonTitle: "Cancel")
        appState[\.routing.alert.configuration] = configuration
    }
    
    func updateCategoryView(with category: Category) {
        appState[\.routing.categoriesList.updateCategory] = category
    }
}
