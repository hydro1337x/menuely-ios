//
//  AcceptInvitationRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation

struct AcceptInvitationBodyRequest: BodyRequestable {
    let invitationId: Int
    let employerId: Int
}
