//
//  UpdateProductRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation

struct UpdateProductMultipartFormDataRequest: MultipartFormDataRequestable {
    struct Parameters: Codable {
        let name: String
        let description: String
        let price: Float
    }
    
    init(data: DataInfo, parameters: Parameters) {
        self.data = data
        self.parameters = parameters
    }
    
    var data: DataInfo
    
    var parameters: Encodable
}
