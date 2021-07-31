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
    
    @Published var routing: CategoriesListView.Routing
    @Published var categories: Loadable<[Category]>
    @Published var operationResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    var title: String {
        return appState[\.routing.menusList.categoriesForMenu]?.name ?? "Categories"
    }
    
    // MARK: - Initialization
    init(appState: Store<AppState>, categories: Loadable<[Category]> = .notRequested, operationResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.categoriesList])
        _categories = .init(initialValue: categories)
        _operationResult = .init(initialValue: operationResult)
        
        cancelBag.collect {
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
        guard let menu = appState[\.routing.menusList.categoriesForMenu] else { return }
        let queryRequestable = CategoriesQueryRequest(menuId: menu.id)
        categoriesService.getCategories(with: queryRequestable, categories: loadableSubject(\.categories))
    }
    
    func deleteCategory(with id: Int) {
        categoriesService.deleteCategory(with: id, deleteCategoryResult: loadableSubject(\.operationResult))
    }
    
    func resetOperationsState() {
        operationResult.reset()
    }
    
    // MARK: - Routing
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
    
    func actionView(for category: Category, with additionalAction: @escaping () -> Void) {
        let delete = Action(name: "Delete") {
            self.appState[\.routing.action.configuration] = nil
            self.deletionAlertView(for: category)
        }
        
        let update = Action(name: "Edit") {
            self.appState[\.routing.action.configuration] = nil
            self.appState[\.routing.categoriesList.updateCategory] = category
        }
        
        let configuration = ActionViewConfiguration(title: "\(category.name) actions", actions: [update, delete]) {
            additionalAction()
            self.appState[\.routing.action.configuration] = nil
        }
        
        appState[\.routing.action.configuration] = configuration
    }
}
