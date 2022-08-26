//
//  NetworkRequest.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

public struct NetworkRequest {
    var path: String
    var parameters: [String: String] = [:]
    var method: HTTPMethod
    var headers: [String: String] = [:]
    var body: Data? = nil
    var responseHandler: NetworkResponseHandler? = nil
    var handlerQoS: DispatchQoS.QoSClass? = nil
    var multipartData: Set<MultipartData> = []
    
    public init(_ path: String,
         parameters: [String: String] = [:],
         method: HTTPMethod = .GET,
         headers: [String: String] = [:],
         body: Data? = nil,
         responseHandler: NetworkResponseHandler? = nil,
         handlerQoS: DispatchQoS.QoSClass? = nil,
         multipartData: Set<MultipartData> = []) {
        self.path = path
        self.parameters = parameters
        self.method = method
        self.headers = headers
        self.body = body
        self.responseHandler = responseHandler
        self.handlerQoS = handlerQoS
        self.multipartData = multipartData
    }
    
    public init(_ path: String,
         parameters: [String: String] = [:],
         method: HTTPMethod,
         headers: [String: String] = [:],
         body: Data? = nil,
         responseHandler: NetworkResponseHandler? = nil,
         handlerQoS: DispatchQoS.QoSClass? = nil,
         multipartData: MultipartData) {
        self.init(path,
                  parameters: parameters,
                  method: method,
                  headers: headers,
                  body: body,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  multipartData: [multipartData])
    }
}
