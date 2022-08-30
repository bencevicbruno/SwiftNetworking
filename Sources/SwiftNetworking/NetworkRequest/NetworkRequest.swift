//
//  NetworkRequest.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

public struct NetworkRequest {
    var path: String
    var parameters: [String: String]
    var parametersEncoding: BodyParametersEncoding
    var method: HTTPMethod
    var headers: [String: String]
    var body: Data?
    var responseHandler: NetworkResponseHandler?
    var handlerQoS: DispatchQoS.QoSClass?
    var multipartData: Set<MultipartData>
    
//    public init(_ path: String,
//                parameters: [String: String] = [:],
//                parametersEncoding: ParametersEncoding = .inUrl,
//                method: HTTPMethod = .GET,
//                headers: [String: String] = [:],
//                body: Data? = nil,
//                responseHandler: NetworkResponseHandler? = nil,
//                handlerQoS: DispatchQoS.QoSClass? = nil,
//                multipartData: Set<MultipartData> = []) {
//        self.path = path
//        self.parameters = parameters
//        self.parametersEncoding = parametersEncoding
//        self.method = method
//        self.headers = headers
//        self.body = body
//        self.responseHandler = responseHandler
//        self.handlerQoS = handlerQoS
//        self.multipartData = multipartData
//    }
    
//    public init(_ path: String,
//                parameters: [String: String] = [:],
//                parametersEncoding: ParametersEncoding = .inUrl,
//                method: HTTPMethod = .GET,
//                headers: [String: String] = [:],
//                body: Data? = nil,
//                responseHandler: NetworkResponseHandler? = nil,
//                handlerQoS: DispatchQoS.QoSClass? = nil,
//                multipartData: MultipartData) {
//        self.init(path,
//                  parameters: parameters,
//                  parametersEncoding: parametersEncoding,
//                  method: method,
//                  headers: headers,
//                  body: body,
//                  responseHandler: responseHandler,
//                  handlerQoS: handlerQoS,
//                  multipartData: [multipartData])
//    }
}

extension NetworkRequest {
    
    public init(_ path: String,
                parameters: [String: String] = [:],
                method: HTTPMethod = .GET,
                headers: [String: String] = [:],
                body: Data? = nil,
                responseHandler: NetworkResponseHandler? = nil,
                handlerQoS: DispatchQoS.QoSClass? = nil) {
        self.init(path: path,
                  parameters: parameters,
                  parametersEncoding: .url,
                  method: method,
                  headers: headers,
                  body: body,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  multipartData: [])
    }
    
    public init(_ path: String,
                bodyParameters: [String: String] = [:],
                parametersEncoding: BodyParametersEncoding,
                method: HTTPMethodForBodyParameters = .GET,
                headers: [String: String] = [:],
                responseHandler: NetworkResponseHandler? = nil,
                handlerQoS: DispatchQoS.QoSClass? = nil) {
        self.init(path: path,
                  parameters: bodyParameters,
                  parametersEncoding: parametersEncoding,
                  method: .init(method),
                  headers: headers,
                  body: nil,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  multipartData: [])
    }
    
    public init(_ path: String,
                urlParameters: [String: String] = [:],
                method: HTTPMethodForMultipartData = .PUT,
                headers: [String: String] = [:],
                multipartData: MultipartData,
                responseHandler: NetworkResponseHandler? = nil,
                handlerQoS: DispatchQoS.QoSClass? = nil) {
        self.init(path: path,
                  parameters: urlParameters,
                  parametersEncoding: .url,
                  method: .init(method),
                  headers: headers,
                  body: nil,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  multipartData: [multipartData])
    }
    
    public init(_ path: String,
                urlParameters: [String: String] = [:],
                method: HTTPMethodForMultipartData = .PUT,
                headers: [String: String] = [:],
                multipartData: Set<MultipartData> = [],
                responseHandler: NetworkResponseHandler? = nil,
                handlerQoS: DispatchQoS.QoSClass? = nil) {
        self.init(path: path,
                  parameters: urlParameters,
                  parametersEncoding: .url,
                  method: .init(method),
                  headers: headers,
                  body: nil,
                  responseHandler: responseHandler,
                  handlerQoS: handlerQoS,
                  multipartData: multipartData)
    }
}
