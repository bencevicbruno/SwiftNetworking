//
//  File.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public struct NetworkRequest {
    public let id: UUID
    public let baseURL: String?
    public let path: String
    public let parameters: [String: String]
    public let parameterEncoding: NetworkRequestParameterEncoding?
    public let method: HTTPMethod
    public let headers: [String: String]
    public let body: NetworkRequestBody?
    public let responseQoS: DispatchQoS.QoSClass?
    public let responseHandler: NetworkResponseHandler?
    
    /// Used for generating standard HTTP requests
    ///
    /// When `baseURL` is `nil`, the baseURL defined in the **Network Service's configuration** is used. Supplying a baseURL in the constructor will **overwrite** the one in the configuration. The same applies to `responseQoS`, `responseHandler` and `parameterEncoding`.
    ///
    /// When supplying some form of body, the type of body will automatically set the `Content-Type` header if one is available. Supplying a `Content-Type` header when constructing a `NetworkRequest` will **override** the one that is automatically provided by body type.
    public init(
        baseURL: String? = nil,
        path: String,
        parameters: [String: String] = [:],
        parameterEncoding: NetworkRequestParameterEncoding? = nil,
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: NetworkRequestBody? = nil,
        responseQoS: QoSClass? = nil,
        responseHandler: NetworkResponseHandler? = nil) {
            self.id = UUID()
            self.baseURL = baseURL
            self.path = path
            self.parameters = parameters
            self.parameterEncoding = parameterEncoding
            self.method = method
            self.headers = headers
            self.body = body
            self.responseQoS = nil
            self.responseHandler = responseHandler
        }
    
    public func createURLRequest(using configuration: NetworkServiceConfiguration) throws -> URLRequest {
        let baseURL = self.baseURL ?? configuration.baseURL
        
        let url: URL
        let parameterEncoding = self.parameterEncoding ?? configuration.networkRequestParameterEncoding
        
        switch parameterEncoding {
        case .default:
            guard var urlComponents = URLComponents(string: baseURL + path) else {
                throw NetworkRequestError.unableToConstructURL(baseURL: baseURL, path: path)
            }
            
            if !parameters.isEmpty {
                urlComponents.queryItems = parameters.map{ .init(name: $0.key, value: $0.value) }
            } else {
                // Prevents adding an unneccessary ? after path
                urlComponents.queryItems = nil
            }
            
            guard let newURL = urlComponents.url else {
                throw NetworkRequestError.unableToConstructURL(urlComponents)
            }
            
            url = newURL
        case let .custom(encoder):
            let customEncodedParameters = try parameters
                .reduce(into: [String: String]()) { result, pair in
                    result[pair.key] = try encoder.encode(pair.value)
                }
                .map { "\($0)=\($1)" }
                .joined(separator: "&")
            
            guard let newURL = URL(string: baseURL + path + "?" + customEncodedParameters) else {
                throw NetworkRequestError.unableToConstructURL(baseURL: baseURL, path: path, parameters: parameters, encoder)
            }
            
            url = newURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.name
        
        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let contentType = body?.getContentType(requestID: self.id) {
            urlRequest.addHeaderIfNotPresent(header: "Content-Type", contentType)
        }
        
        urlRequest.httpBody = try body?.generateData(requestID: self.id, jsonEncoder: configuration.jsonEncoder)
        
        return urlRequest
    }
    
    public func bodyDescription(using configuration: NetworkServiceConfiguration) -> String {
        return body?.getBodyDescription(requestID: self.id, jsonEncoder: configuration.jsonEncoder) ?? "Empty"
    }
}
