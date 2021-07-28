//
//  DataInfo.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 14.07.2021..
//

import Foundation

enum MimeType: String, Codable {
    case jpeg = "image/jpeg"
    
    var associatedExtension: String {
        switch self {
        case .jpeg: return ".jpeg"
        }
    }
}

struct DataInfo: Codable {
    let fileName: String
    let mimeType: MimeType
    let file: Data
    let fieldName: String
    
    init(mimeType: MimeType, file: Data, fieldName: String) {
        self.fileName = UUID().uuidString + mimeType.associatedExtension
        self.mimeType = mimeType
        self.file = file
        self.fieldName = fieldName
    }
    
    
}
