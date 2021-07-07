//
//  Networkable.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Foundation
import Alamofire
import Resolver

typealias Parameters = Alamofire.Parameters
typealias HTTPMethod = Alamofire.HTTPMethod

protocol APIConfigurable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: Parameters? { get }
    func body() throws -> Data?
}

extension APIConfigurable {
    var baseURL: String {
        return "https://menuely.herokuapp.com"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.allHTTPHeaderFields = headers
        
        // Query Parameters
        if let queryParameters = self.queryParameters {
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

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
