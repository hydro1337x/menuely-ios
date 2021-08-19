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
        
        @Published var routing: Routing
        @Published var invitations: Loadable<[Invitation]>
        @Published var actionResult: Loadable<Discardable>
        
        var title: String {
            switch appState[\.data.selectedEntity] {
            case .user: return "Incoming invitations"
            case .restaurant: return "Outgoing invitations"
            }
        }
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, invitations: Loadable<[Invitation]> = .notRequested, actionResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.invitationsList])
            
            _invitations = .init(initialValue: invitations)
            _actionResult = .init(initialValue: actionResult)
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.invitationsList] = $0 }

                appState
                    .map(\.routing.invitationsList)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func getInvitations() {
            invitationsService.getInvitations(invitations: loadableSubject(\.invitations))
        }
        
        func acceptInvitation(_ invitation: Invitation) {
            let bodyRequest = AcceptInvitationBodyRequest(invitationId: invitation.id, employerId: invitation.employer.id)
            invitationsService.acceptInvitation(with: bodyRequest, acceptInvitationResult: loadableSubject(\.actionResult))
        }
        
        func rejectInvitation(_ invitation: Invitation) {
            let bodyRequest = RejectInvitationBodyRequest(invitationId: invitation.id)
            invitationsService.rejectInvitation(with: bodyRequest, rejectInvitationResult: loadableSubject(\.actionResult))
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
        
        func userNoticeView(for id: Int) {
            routing.userNoticeForID = id
        }
        
        func restaurantNoticeView(for id: Int) {
            let info = RestaurantNoticeInfo(restaurantID: id, tableID: nil)
            routing.restaurantNoticeForInfo = info
        }
    }
}
