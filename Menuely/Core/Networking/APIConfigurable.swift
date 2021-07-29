//
//  Networkable.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Foundation
import Alamofire
import Resolver

typealias HTTPMethod = Alamofire.HTTPMethod

typealias PathParameter = Int
protocol QueryRequestable: Encodable {}
protocol BodyRequestable: Encodable {}
protocol MultipartFormDataRequestable {
    var data: DataInfo { get set }
    var parameters: Encodable { get set }
}

extension MultipartFormDataRequestable {
    func asMultipartFormData() throws -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        let dataInfo = self.data
        guard let parameters = self.parameters.asDictionary else { throw DataError.malformed }
        
        for (key, value) in parameters {
            guard value is String || value is Int else { throw DataError.malformed }
            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
        }
        
        multipartFormData.append(dataInfo.file, withName: dataInfo.fieldName, fileName: dataInfo.fileName, mimeType: dataInfo.mimeType.rawValue)
        
        return multipartFormData
    }
}

protocol APIConfigurable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryRequestable: QueryRequestable? { get }
    var bodyRequestable: BodyRequestable? { get }
    var multipartFormDataRequestable: MultipartFormDataRequestable? { get }
}

extension APIConfigurable {
    var baseURL: String {
        return "https://menuely-eyj6bxkacq-ey.a.run.app"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.allHTTPHeaderFields = headers
        
        // Query Parameters
        if let queryParameters = self.queryRequestable?.asDictionary {
            let parameters = queryParameters.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = parameters
            urlRequest.url = components?.url
        }
        
        
        // Body
        // FIXME: - Add Content-Type application/json headers here and remove them from repositories
        if let bodyRequestable = self.bodyRequestable {
            urlRequest.httpBody = try bodyRequestable.asJSON()
        }
        
        if let multipartFormDataRequestable = self.multipartFormDataRequestable {
            let multipartFormData = try multipartFormDataRequestable.asMultipartFormData()
            urlRequest.setValue("multipart/form-data; boundary=\(multipartFormData.boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try multipartFormData.encode()
        }
        
        return urlRequest
    }
}

enum NetworkError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case refreshTokenMissing
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected server response"
        case .refreshTokenMissing: return "Missing refresh token"
        }
    }
}

enum DataError: Error {
    case missing
    case decoder
    case malformed
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missing: return "Missing data"
        case .decoder: return "Decoder error"
        case .malformed: return "Malformed data"
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

extension MultipartFormData {
    convenience init() {
        self.init(fileManager: FileManager(), boundary: String(format: "%08X%08X", arc4random(), arc4random()))
    }
}
