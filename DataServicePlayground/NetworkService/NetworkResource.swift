//
//  NetworkRequest.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation

struct NetworkResource {
    var path: String
    var parameters: [String: String] = [:]
    var method: HTTPMethod
    var headers: [String: String] = [:]
    var body: Data? = nil
    var responseHandler: NetworkResponseHandler? = nil
    var handlerQoS: DispatchQoS.QoSClass? = nil
    var uploadableData: Set<UploadableData> = []
    
    init(_ path: String,
         parameters: [String: String] = [:],
         method: HTTPMethod = .GET,
         headers: [String: String] = [:],
         body: Data? = nil,
         responseHandler: NetworkResponseHandler? = nil,
         handlerQoS: DispatchQoS.QoSClass? = nil,
         uploadableData: Set<UploadableData> = []) {
        self.path = path
        self.parameters = parameters
        self.method = method
        self.headers = headers
        self.body = body
        self.responseHandler = responseHandler
        self.handlerQoS = handlerQoS
        self.uploadableData = uploadableData
    }
}

extension NetworkResource {
    
    init(_ path: String,
         parameters: [String: String] = [:],
         method: HTTPMethod,
         headers: [String: String] = [:],
         body: Data? = nil,
         responseHandler: NetworkResponseHandler? = nil,
         handlerQoS: DispatchQoS.QoSClass? = nil,
         uploadableData: UploadableData) {
        self.init(path,
                  parameters: parameters,
                  method: method,
                  headers: headers,
                  body: body,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  uploadableData: [uploadableData])
    }
}
