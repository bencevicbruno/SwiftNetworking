//
//  NetworkLogger.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

public class NetworkLogger {
    
    internal init() {}
    
    func log(_ message: String) {
        fatalError("NetworkLogger#log(message) not implemented!")
    }
    
    func log(_ error: Error) {
        fatalError("NetworkLogger#log(error) not implemented!")
    }
    
    func log(_ loggable: NetworkLoggable) {
        fatalError("NetworkLogger#log(loggable) not implemented!")
    }
}

public extension NetworkLogger {
    
    static var consoleLogger: NetworkLogger {
        ConsoleNetworkLogger()
    }
}
