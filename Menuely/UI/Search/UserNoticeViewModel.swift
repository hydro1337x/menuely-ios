//
//  UserNoticeViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 04.08.2021..
//

import Foundation
import Resolver

extension UserNoticeView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var usersService: UsersServicing
        @Injected private var invitationsService: InvitationsServicing
        
        @Published var user: Loadable<User>
        @Published var createInvitationResult: Loadable<Discardable>
        
        var appState: Store<AppState>
        private let cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, user: Loadable<User> = .notRequested, createInvitationResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _user = .init(initialValue: user)
            _createInvitationResult = .init(initialValue: createInvitationResult)
        }
        
        // MARK: - Methods
        func getUser() {
            guard let id = appState[\.routing.usersSearch.userNoticeForID] else { return }
            usersService.getUser(with: id, user: loadableSubject(\.user))
        }
        
        func createInvitation() {
            guard let id = appState[\.routing.usersSearch.userNoticeForID] else { return }
            let bodyRequest = CreateInvitationBodyRequest(employeeId: id)
            invitationsService.createInvitation(with: bodyRequest, createInvitationResult: loadableSubject(\.createInvitationResult))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func infoView() {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Invitation sent successfully", message: nil)
        }
    }
}
