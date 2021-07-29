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
typealias DataParameters = [String: DataInfo]

protocol PathRequestable: Encodable {}
protocol QueryRequestable: Encodable {}
protocol BodyRequestable: Encodable {}
protocol MultipartFormDataRequestable {
    var data: DataInfo { get set }
    var parameters: Encodable { get set }
}

protocol APIConfigurable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: QueryRequestable? { get }
    func body() throws -> Data?
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
        if let queryParameters = self.query?.asDictionary {
            let parameters = queryParameters.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = parameters
            urlRequest.url = components?.url
        }
        
        
        // Body
        urlRequest.httpBody = try body()
        
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
