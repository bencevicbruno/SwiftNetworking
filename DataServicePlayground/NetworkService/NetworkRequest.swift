//
//  NetworkRequest.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation

struct NetworkRequest {
    var path: String
    var headers: [String:String]
    var parameters: [String:String]
    var httpMethod: HTTPMethod
    var resourceEncoding: ResourceEncoding
    var body: [String: Any]?
    var responseHandler: NetworkResponseHandler?
    
    init(path: String, headers: [String:String] = [:], parameters: [String:String] = [:], httpMethod: HTTPMethod = .GET, resourceEncoding: ResourceEncoding = .json, body: [String: Encodable]? = nil, responseHandler: NetworkResponseHandler? = nil) {
        self.path = path
        self.headers = headers
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.resourceEncoding = resourceEncoding
        self.body = body
        self.responseHandler = responseHandler
    }
}
