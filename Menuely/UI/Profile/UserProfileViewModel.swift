//
//  UserProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Resolver
import UIKit

class UserProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var usersService: UsersServicing
    @Injected private var dateUtility: DateUtility
    
    @Published var routing: ProfileView.Routing
    @Published var userProfile: Loadable<User>
    
    var selectedProfileImage: UIImage? {
        didSet {
            uploadImageAndGetUserProfil(imagaKind: .profile)
        }
    }
    var selectedCoverImage: UIImage? {
        didSet {
            uploadImageAndGetUserProfil(imagaKind: .cover)
        }
    }
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, userProfile: Loadable<User> = .notRequested) {
        self.appState = appState
        
        _userProfile = .init(initialValue: userProfile)
        
        _routing = .init(initialValue: appState[\.routing.profile])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.profile] = $0 }
            
            appState
                .map(\.routing.profile)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
            
            appState
                .map(\.data.updateUserProfileView)
                .removeDuplicates()
                .sink { shouldUpdateUserProfileView in
                    if shouldUpdateUserProfileView {
                        appState[\.data.updateUserProfileView] = false
                        self.getUserProfile()
                    }
                }
        }
    }
    
    // MARK: - Methods
    func getUserProfile() {
        guard appState[\.data.authenticatedUser] != nil else { return }
        usersService.getUserProfile(user: loadableSubject(\.userProfile))
    }
    
    func uploadImageAndGetUserProfil(imagaKind: ImageKind) {
        var imageData: Data?
        switch imagaKind {
        case .profile:
            imageData = selectedProfileImage?.jpegData(compressionQuality: 0.5)
        case .cover:
            imageData = selectedCoverImage?.jpegData(compressionQuality: 0.5)
        }
        guard let imageData = imageData else { return }
        let parameters = UpdateImageMultipartFormDataRequest.Parameters(kind: imagaKind)
        let data = DataInfo(mimeType: .jpeg, file: imageData, fieldName: "image")
        let updateImageMultipartFormDataRequest = UpdateImageMultipartFormDataRequest(data: data, parameters: parameters)
        userProfile.reset()
        usersService.uploadImageAndGetUserProfile(with: updateImageMultipartFormDataRequest, user: loadableSubject(\.userProfile))
    }
    
    func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
        return dateUtility.formatToString(from: timeInterval, with: .full)
    }
    
    // MARK: - Routing
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
