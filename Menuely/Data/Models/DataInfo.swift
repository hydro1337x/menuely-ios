//
//  DataInfo.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 14.07.2021..
//

import Foundation

enum MimeType: String {
    case jpeg = "image/jpeg"
    
    var associatedExtension: String {
        switch self {
        case .jpeg: return ".jpeg"
        }
    }
}

struct DataInfo {
    let fileName: String
    let mimeType: MimeType
    let file: Data
    
    init(mimeType: MimeType, file: Data) {
        self.fileName = UUID().uuidString + mimeType.associatedExtension
        self.mimeType = mimeType
        self.file = file
    }
}
