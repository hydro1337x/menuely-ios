//
//  CreateCategoryRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation

struct CreateCategoryMultipartFormDataRequest: MultipartFormDataRequestable {
    struct Parameters: Codable {
        let name: String
        let menuId: Int
    }
    
    init(data: DataInfo, parameters: Parameters) {
        self.data = data
        self.parameters = parameters
    }
    
    var data: DataInfo
    
    var parameters: Encodable
}
