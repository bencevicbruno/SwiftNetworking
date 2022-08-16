//
//  NetworkServiceConfiguration.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation

struct NetworkServiceConfiguration {
    let baseURL: String
    let staticHeaders: [String:String]
    let logger: NetworkLogger?
    let sessionName: String
    let responseHandler: NetworkResponseHandler
    
    init(baseURL: String, statisHeaders: [String:String] = [:], logger: NetworkLogger? = nil, sessionName: String, responseHandler: NetworkResponseHandler = DefaultResponseHandler(logger: ConsoleNetworkLogger.instance)) {
        self.baseURL = baseURL
        self.staticHeaders = statisHeaders
        self.logger = logger
        self.sessionName = sessionName
        self.responseHandler = responseHandler
    }
}
