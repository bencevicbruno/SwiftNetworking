//
//  HTTPURLResponse+NetworkLoggable.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

extension HTTPURLResponse: NetworkLoggable {
    
    public var networkLoggerDescription: String {
        var result = ""
        
        result += "URL: \(url?.description ?? "Unknown")\n"
        result += "Status Code: \(statusCode)\n"
        result += "Headers: \n"
        
        result += allHeaderFields.map { "\t\($0): \($1)" }.sorted().joined(separator: "\n")
        
        return result
    }
}
