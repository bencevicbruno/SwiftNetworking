//
//  URLRequest+NetworkLoggable.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension URLRequest: NetworkLoggable {
    
    public var networkLoggerDescription: String {
        var result = ""
        
        result += "URL: " + (self.url?.absoluteString ?? "nil") + "\n"
        result += "Method: " + (self.httpMethod ?? "nil") + "\n"
        
        if let headers = self.allHTTPHeaderFields {
            result += "Headers:\n"
            
            for (header, value) in headers {
                result += "\t\(header): \(value)\n"
            }
        } else {
            result += "Headers: Empty\n"
        }
        
        return result
    }
}
