//
//  ConsoleNetworkLogger.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

public class ConsoleNetworkLogger: NetworkLogger {
    
    internal override init() {
        super.init()
    }
    
    override func log(_ message: String) {
        print(message)
    }
    
    override func log(_ error: Error) {
        if let error = error as? NetworkLoggable {
            print(error.networkLoggerDescription)
        } else {
            print("Error:\n\t\(error)")
        }
    }
    
    override func log(_ loggable: NetworkLoggable) {
        print(loggable.networkLoggerDescription)
    }
}
