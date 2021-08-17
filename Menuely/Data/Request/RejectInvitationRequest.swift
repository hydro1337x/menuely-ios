//
//  RejectInvitationRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation

struct RejectInvitationBodyRequest: BodyRequestable {
    let invitationId: Int
}
