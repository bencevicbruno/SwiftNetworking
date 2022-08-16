//
//  NetworkExtensions.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 14.08.2022..
//

import Foundation

// TODO: - Seperate into extensions of each type

extension HTTPURLResponse: NetworkLoggable {
    
    var networkLoggerDescription: String {
        var result = ""
        
        result += "URL: \(url?.description ?? "Unknown")\n"
        result += "Status Code: \(statusCode)\n"
        result += "Headers: \n"
        
        result += allHeaderFields.map { "\t\($0): \($1)" }.sorted().joined(separator: "\n")
        
        return result
    }
}

extension URLError: NetworkLoggable {
    
    var networkLoggerDescription: String {
        var result = ""
        
        result += "Type: URL\n"
        result += "Failing URL: \(failureURLString ?? "Unknown")\n"
        result += "Domain Code: \(errorCode)\n"
        result += "Description: \(localizedDescription)\n"
        
        return result
    }
}
