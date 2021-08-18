//
//  InvitationsListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation
import Resolver

extension InvitationsListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var invitationsService: InvitationsServicing
        
//        @Published var routing: Routing
        @Published var invitations: Loadable<[Invitation]>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, invitations: Loadable<[Invitation]> = .notRequested) {
            self.appState = appState
            
//            _routing = .init(initialValue: appState[\.routing.invitationsList])
            
            _invitations = .init(initialValue: invitations)
            
            cancelBag.collect {
//                $routing
//                    .removeDuplicates()
//                    .sink { appState[\.routing.invitationsList] = $0 }
//
//                appState
//                    .map(\.routing.invitationsList)
//                    .removeDuplicates()
//                    .assign(to: \.routing, on: self)
            }
                
        }
        
        // MARK: - Methods
        func getInvitations() {
            invitationsService.getInvitations(invitations: loadableSubject(\.invitations))
        }
        
        func resetStates() {
            invitations.reset()
        }
        
        func imageUrl(for invitation: Invitation) -> URL? {
            return appState[\.data.selectedEntity] == .user ? URL(string: invitation.employer.profileImage?.url ?? "") : URL(string: invitation.employee.profileImage?.url ?? "")
        }
        
        func title(for invitation: Invitation) -> String {
            return appState[\.data.selectedEntity] == .user ? invitation.employer.name : invitation.employee.name
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
