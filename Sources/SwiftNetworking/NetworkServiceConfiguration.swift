//
//  NetworkServiceConfiguration.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public struct NetworkServiceConfiguration {
    let baseURL: String
    let staticHeaders: [String: String]
    let logger: NetworkLogger?
    let sessionName: String
    let responseQoS: DispatchQoS.QoSClass
    let responseHandler: NetworkResponseHandler
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    let networkRequestParameterEncoding: NetworkRequestParameterEncoding
    
    public init(baseURL: String,
                staticHeaders: [String: String] = [:],
                logger: NetworkLogger? = nil,
                sessionName: String,
                responseHandler: NetworkResponseHandler = DefaultResponseHandler(logger: .timed),
                responseQoS: DispatchQoS.QoSClass = .userInteractive,
                jsonEncoder: JSONEncoder = .default,
                jsonDecoder: JSONDecoder = .default,
                networkRequestParameterEncoding: NetworkRequestParameterEncoding = .default) {
        self.baseURL = baseURL
        self.staticHeaders = staticHeaders
        self.logger = logger
        self.sessionName = sessionName
        self.responseQoS = responseQoS
        self.responseHandler = responseHandler
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.networkRequestParameterEncoding = networkRequestParameterEncoding
    }
}
