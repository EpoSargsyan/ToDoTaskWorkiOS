//
//  EndpointProvider.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

public enum RequestMethod: String {

    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

public protocol IEndpointProvider {

    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var accessToken: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }
    var multipart: MultipartRequest? { get }
    var uploadData: Data? { get }
}

public extension IEndpointProvider {

    var scheme: String {
        ApiConfig.scheme
    }

    var baseURL: String {
        ApiConfig.baseUrl
    }

    var accessToken: String {
        ApiConfig.accessToken
    }

    var refreshToken: String {
        ApiConfig.refreshToken
    }

    var multipart: MultipartRequest? {
        nil
    }

    var uploadData: Data? {
        nil
    }
    
    var mockFile: String? {
        nil
    }

    func asURLRequest() throws -> URLRequest { // 4

        var urlComponents = URLComponents() // 5
        urlComponents.scheme = scheme
        urlComponents.host =  baseURL
        urlComponents.path = path
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw ApiError(message: "URL error")
        }

        var urlRequest = URLRequest(url: url) // 6
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
        urlRequest.addValue("ios", forHTTPHeaderField: "X-Platform")

        //Multipart
        if let multipart = multipart {
            urlRequest.setValue(multipart.headerValue, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(multipart.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = multipart.httpBody
        }

        var uploadData: Data? {
            return nil
        }

        if !accessToken.isEmpty {
            urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if !refreshToken.isEmpty {
            urlRequest.addValue(refreshToken, forHTTPHeaderField: "X-Authorization")
        }

        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw ApiError(message: "Error encoding http body")
            }
        }
        return urlRequest
    }
}
