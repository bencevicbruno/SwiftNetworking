//
//  File.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

extension URLError: NetworkLoggable {
    
    public var networkLoggerDescription: String {
        var result = ""
        
        result += "Type: URL\n"
        result += "Failing URL: \(failureURLString ?? "Unknown")\n"
        result += "Domain Code: \(errorCode)\n"
        result += "Description: \(localizedDescription)\n"
        
        return result
    }
}
