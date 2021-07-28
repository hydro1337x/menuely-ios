//
//  RestaurantProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Resolver
import UIKit

class RestaurantProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var restaurantsService: RestaurantsServicing
    @Injected private var dateUtility: DateUtility
    
    @Published var routing: ProfileView.Routing
    @Published var restaurantProfile: Loadable<Restaurant>
    
    var selectedProfileImage: UIImage? {
        didSet {
            uploadImageAndGetRestaurantProfil(imagaKind: .profile)
        }
    }
    var selectedCoverImage: UIImage? {
        didSet {
            uploadImageAndGetRestaurantProfil(imagaKind: .cover)
        }
    }
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, restaurantProfile: Loadable<Restaurant> = .notRequested) {
        self.appState = appState
        
        _restaurantProfile = .init(initialValue: restaurantProfile)
        
        _routing = .init(initialValue: appState[\.routing.profile])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { [weak self] in
                    guard self != nil else { return }
                    appState[\.routing.profile] = $0 }
            
            appState
                .map(\.routing.profile)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
            
            appState
                .map(\.data.updateRestaurantProfileView)
                .removeDuplicates()
                .sink { shouldUpdateRestaurantProfileView in
                    if shouldUpdateRestaurantProfileView {
                        appState[\.data.updateRestaurantProfileView] = false
                        self.getRestaurantProfile()
                    }
                }
        }
    }
    
    // MARK: - Methods
    func getRestaurantProfile() {
        guard appState[\.data.authenticatedRestaurant] != nil else { return }
        restaurantsService.getRestaurantProfile(restaurant: loadableSubject(\.restaurantProfile))
    }
    
    func uploadImageAndGetRestaurantProfil(imagaKind: ImageKind) {
        var imageData: Data?
        switch imagaKind {
        case .profile:
            imageData = selectedProfileImage?.jpegData(compressionQuality: 0.5)
        case .cover:
            imageData = selectedCoverImage?.jpegData(compressionQuality: 0.5)
        }
        guard let imageData = imageData else { return }
        let dataParameters = ["image": DataInfo(mimeType: .jpeg, file: imageData, fieldName: "")]
        restaurantProfile.reset()
        restaurantsService.uploadImageAndGetRestaurantProfile(with: dataParameters, ofKind: imagaKind, restaurant: loadableSubject(\.restaurantProfile))
    }
    
    func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
        return dateUtility.formatToString(from: timeInterval, with: .full)
    }
    
    // MARK: - Routing
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
