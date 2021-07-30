//
//  CreateProductRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation

struct CreateProductMultipartFormDataRequest: MultipartFormDataRequestable {
    struct Parameters: Codable {
        let name: String
        let description: String
        let price: Float
        let categoryId: Int
    }
    
    init(data: DataInfo, parameters: Parameters) {
        self.data = data
        self.parameters = parameters
    }
    
    var data: DataInfo
    
    var parameters: Encodable
}
