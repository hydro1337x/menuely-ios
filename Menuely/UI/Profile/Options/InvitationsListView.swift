//
//  InvitationsListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import SwiftUI
import Resolver

struct InvitationsListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            listContent
            actionContent
        }
        .sheet(isPresented: viewModel.routing.userNoticeForID == nil ? .constant(false) : .constant(true), onDismiss: {
            viewModel.routing.userNoticeForID = nil
        }, content: {
            UserNoticeView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
        .fullScreenCover(isPresented: viewModel.routing.restaurantNoticeForInfo == nil ? .constant(false) : .constant(true), content: {
            RestaurantNoticeView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
        .navigationBarTitle(viewModel.title)
    }
}

private extension InvitationsListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.invitations {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let invitations):  listLoadedView(invitations, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
    
    @ViewBuilder
    private var actionContent: some View {
        switch viewModel.actionResult {
        case .notRequested: EmptyView()
        case .isLoading(_, _):  listLoadingView(nil)
        case .loaded(_):  actionLoadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension InvitationsListView {
    var listNotRequestedView: some View {
        Text("").onAppear(perform: viewModel.getInvitations)
    }
    
    func listLoadingView(_ previouslyLoaded: [Invitation]?) -> some View {
        if let invitations = previouslyLoaded {
            return AnyView(listLoadedView(invitations, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func operationLoadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension InvitationsListView {
    func listLoadedView(_ invitations: [Invitation], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return ScrollView {
            LazyVStack {
                ForEach(invitations) { invitation in
                    switch viewModel.appState[\.data.selectedEntity] {
                    case .user: userInvitationCell(for: invitation)
                    case .restaurant: restaurantInvitationCell(for: invitation)
                    }
                }
            }
        }
        
    }
    
    func actionLoadedView() -> some View {
        viewModel.actionResult.reset()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.getInvitations()
        return EmptyView()
    }
    
    func userInvitationCell(for invitation: Invitation) -> some View {
        InvitationCell(title: viewModel.title(for: invitation), imageURL: viewModel.imageUrl(for: invitation), primaryAction: {
            viewModel.acceptInvitation(invitation)
        }, primaryButtonTitle: "Accept", secondaryAction: {
            viewModel.rejectInvitation(invitation)
        }, secondaryButtonTitle: "Decline")
            .onTapGesture {
                viewModel.restaurantNoticeView(for: invitation.employer.id)
            }
    }
    
    func restaurantInvitationCell(for invitation: Invitation) -> some View {
        InvitationCell(title: viewModel.title(for: invitation), imageURL: viewModel.imageUrl(for: invitation), primaryAction: {
            viewModel.rejectInvitation(invitation)
        }, primaryButtonTitle: "Cancel", secondaryAction: nil, secondaryButtonTitle: nil)
            .onTapGesture {
                viewModel.userNoticeView(for: invitation.employee.id)
            }
    }
}

extension InvitationsListView {
    struct Routing: Equatable {
        var restaurantNoticeForInfo: RestaurantNoticeInfo?
        var userNoticeForID: Int?
    }
}

struct InvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsListView()
    }
}
