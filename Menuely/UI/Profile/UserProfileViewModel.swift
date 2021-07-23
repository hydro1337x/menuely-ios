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
    @Published var animateErrorView: Bool = false
    
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
        }
    }
    
    // MARK: - Methods
    func getUserProfile() {
        usersService.getUserProfile(user: loadableSubject(\.userProfile))
    }
    
    func uploadImageAndGetUserProfil(imagaKind: ImageKind) {
        var imageData: Data?
        switch imagaKind {
        case .profile:
            imageData = selectedProfileImage?.jpegData(compressionQuality: 0.5)
        default:
            imageData = selectedCoverImage?.jpegData(compressionQuality: 0.5)
        }
        guard let imageData = imageData else { return }
        let dataParameters = ["image": DataInfo(mimeType: .jpeg, file: imageData)]
        userProfile.reset()
        usersService.uploadImageAndGetUserProfile(with: dataParameters, ofKind: imagaKind, user: loadableSubject(\.userProfile))
    }
    
    func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
        return dateUtility.formatToString(from: timeInterval, with: .full)
    }
    
    func resetStates() {
        userProfile.reset()
    }
}
