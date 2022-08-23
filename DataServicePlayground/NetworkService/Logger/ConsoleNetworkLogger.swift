//
//  ConsoleNetworkLogger.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 14.08.2022..
//

import Foundation

struct ConsoleNetworkLogger: NetworkLogger {
    
    static let instance = ConsoleNetworkLogger()
    
    private init() {}
    
    func log(_ message: String) {
        print(message)
    }
    
    func log(_ error: Error) {
        if let error = error as? NetworkLoggable {
            print(error.networkLoggerDescription)
        } else {
            print("Error:\n\t\(error)")
        }
    }
    
    func log(_ loggable: NetworkLoggable) {
        print(loggable.networkLoggerDescription)
    }
}
