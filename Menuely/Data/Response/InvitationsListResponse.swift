//
//  InvitationsListResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation

struct InvitationsListResponse: Decodable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case invitations = "data"
        case statusCode
    }
    
    let statusCode: Int
    var invitations: [Invitation]
}
