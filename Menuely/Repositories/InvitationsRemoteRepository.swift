//
//  InvitationsRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.08.2021..
//

import Foundation
import Resolver
import Combine
import Alamofire

protocol InvitationsRemoteRepositing {
    func getInvitations() -> AnyPublisher<InvitationsListResponse, Error>
    func createInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func acceptInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func rejectInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
}

class InvitationsRemoteRepository: InvitationsRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getInvitations() -> AnyPublisher<InvitationsListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getInvitations)
    }
    
    func createInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createInvitation(bodyRequest))
    }
    
    func acceptInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.acceptInvitation(bodyRequest))
    }
    
    func rejectInvitation(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.rejectInvitation(bodyRequest))
    }
}

// MARK: - Endpoints

extension InvitationsRemoteRepository {
    enum Endpoint {
        case getInvitations
        case createInvitation(BodyRequestable)
        case acceptInvitation(BodyRequestable)
        case rejectInvitation(BodyRequestable)
    }
}

extension InvitationsRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getInvitations: return "/invitations"
        case .createInvitation: return "/invitations/create"
        case .acceptInvitation: return "/invitations/accept"
        case .rejectInvitation: return "/invitations/reject"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getInvitations: return .get
        case .createInvitation: return .post
        case .acceptInvitation: return .post
        case .rejectInvitation: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getInvitations: return nil
        case .createInvitation: return ["Content-Type": "application/json"]
        case .acceptInvitation: return ["Content-Type": "application/json"]
        case .rejectInvitation: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
       return nil
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .getInvitations: return nil
        case .createInvitation(let bodyRequest): return bodyRequest
        case .acceptInvitation(let bodyRequest): return bodyRequest
        case .rejectInvitation(let bodyRequest): return bodyRequest
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
