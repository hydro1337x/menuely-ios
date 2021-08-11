//
//  UpdateUserImageRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.07.2021..
//

import Foundation

struct UpdateImageMultipartFormDataRequest: MultipartFormDataRequestable {
    struct Parameters: Codable {
        var kind: ImageKind
    }
    
    init(data: DataInfo, parameters: Parameters) {
        self.data = data
        self.parameters = parameters
    }
    
    var data: DataInfo?
    
    var parameters: Encodable
}
