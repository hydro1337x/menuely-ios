//
//  MultipartFormatter.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.07.2021..
//

import Foundation
import Alamofire

class MultipartFormatter {
    func format(_ multipartFormRequest: MultipartFormDataRequestable) -> MultipartFormData? {
        let multipartFormData = MultipartFormData()
        let dataInfo = multipartFormRequest.data
        guard let parameters = multipartFormRequest.parameters.asDictionary else { return nil }
        
        for (key, value) in parameters {
            guard value is String || value is Int else { return nil }
            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
        }
        
        multipartFormData.append(dataInfo.file, withName: dataInfo.fieldName, fileName: dataInfo.fileName, mimeType: dataInfo.mimeType.rawValue)
        
        return multipartFormData
    }
}
