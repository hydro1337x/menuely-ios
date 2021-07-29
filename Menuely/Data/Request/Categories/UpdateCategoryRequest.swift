//
//  UpdateCategoryRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation

struct UpdateCategoryMultipartFormDataRequest: MultipartFormDataRequestable {
    struct Parameters: Codable {
        let name: String
    }
    
    init(data: DataInfo, parameters: Parameters) {
        self.data = data
        self.parameters = parameters
    }
    
    var data: DataInfo
    
    var parameters: Encodable
}
