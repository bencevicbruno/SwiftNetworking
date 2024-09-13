//
//  URLError+NetworkLoggable.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
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
