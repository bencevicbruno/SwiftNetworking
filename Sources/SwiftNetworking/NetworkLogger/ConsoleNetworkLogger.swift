//
//  ConsoleNetworkLogger.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public struct ConsoleNetworkLogger: NetworkLogger {
    
    public static let instance = ConsoleNetworkLogger()
    
    private init() {}
    
    public func log(_ message: String) {
        print(message)
    }
    
    public func log(_ loggable: NetworkLoggable) {
        print(loggable.networkLoggerDescription)
    }
}

public extension NetworkLogger where Self == ConsoleNetworkLogger {
    
    static var `default`: NetworkLogger { ConsoleNetworkLogger.instance }
}
