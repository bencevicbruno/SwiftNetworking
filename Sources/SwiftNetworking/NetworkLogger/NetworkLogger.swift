//
//  NetworkLogger.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public protocol NetworkLogger {
    
    func log(_ message: String)
    func log(_ loggable: NetworkLoggable)
}

public extension NetworkLogger {
    
    func log() {
        log("")
    }
}
