//
//  File.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

public struct NetworkServiceConfiguration {
    let baseURL: String
    let staticHeaders: [String:String]
    let logger: NetworkLogger?
    let sessionName: String
    let responseHandler: NetworkResponseHandler
    let completionThread: DispatchQoS.QoSClass
    
    public init(baseURL: String, statisHeaders: [String:String] = [:], logger: NetworkLogger? = nil, sessionName: String, responseHandler: NetworkResponseHandler = .default, completionThread: DispatchQoS.QoSClass = .userInteractive) {
        self.baseURL = baseURL
        self.staticHeaders = statisHeaders
        self.logger = logger
        self.sessionName = sessionName
        self.responseHandler = responseHandler
        self.completionThread = completionThread
    }
}

