//
//  TimedConsoleNetworkLogger.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public struct TimedConsoleNetworkLogger: NetworkLogger {
    
    public static let instance = TimedConsoleNetworkLogger()
    
    private init() {}
    
    public func log(_ message: String) {
        let currentTime = Date()
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
        let hours = (timeComponents.hour ?? 0).asTwoDigit
        let minutes = (timeComponents.minute ?? 0).asTwoDigit
        let seconds = (timeComponents.second ?? 0).asTwoDigit
        
        print("[\(hours):\(minutes):\(seconds)]: \(message)")
    }
    
    public func log(_ loggable: NetworkLoggable) {
        log(loggable.networkLoggerDescription)
    }
}

public extension NetworkLogger where Self == ConsoleNetworkLogger {
    
    static var timed: NetworkLogger { TimedConsoleNetworkLogger.instance }
}

