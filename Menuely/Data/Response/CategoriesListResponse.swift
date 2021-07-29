//
//  CategoriesListResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation

struct CategoriesListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case categories = "data"
        case statusCode
    }
    
    let statusCode: Int
    let categories: [Category]
}
