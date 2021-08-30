//
//  InvitationsService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation
import Combine
import Resolver

protocol InvitationsServicing {
    func getInvitations(invitations: LoadableSubject<[Invitation]>)
    func createInvitation(with bodyRequest: BodyRequestable, createInvitationResult: LoadableSubject<Discardable>)
    func acceptInvitation(with bodyRequest: BodyRequestable, acceptInvitationResult: LoadableSubject<Discardable>)
    func rejectInvitation(with bodyRequest: BodyRequestable, rejectInvitationResult: LoadableSubject<Discardable>)
}

class InvitationsService: InvitationsServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: InvitationsRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func getInvitations(invitations: LoadableSubject<[Invitation]>) {
        invitations.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getInvitations()
            }
            .map { $0.invitations }
            .sinkToLoadable { invitations.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func createInvitation(with bodyRequest: BodyRequestable, createInvitationResult: LoadableSubject<Discardable>) {
        createInvitationResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.createInvitation(with: bodyRequest)
            }
            .sinkToLoadable { createInvitationResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func acceptInvitation(with bodyRequest: BodyRequestable, acceptInvitationResult: LoadableSubject<Discardable>) {
        acceptInvitationResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.acceptInvitation(with: bodyRequest)
            }
            .sinkToLoadable { acceptInvitationResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func rejectInvitation(with bodyRequest: BodyRequestable, rejectInvitationResult: LoadableSubject<Discardable>) {
        rejectInvitationResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.rejectInvitation(with: bodyRequest)
            }
            .sinkToLoadable { rejectInvitationResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
