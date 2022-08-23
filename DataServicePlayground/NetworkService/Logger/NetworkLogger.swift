//
//  NetworkLogger.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 14.08.2022..
//

import Foundation

protocol NetworkLogger {
    
    func log(_ message: String)
    func log(_ error: Error)
    func log(_ loggable: NetworkLoggable)
}
