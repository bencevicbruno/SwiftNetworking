//
//  HTTPURLResponse+NetworkLoggable.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension HTTPURLResponse {
    
    @objc public override var networkLoggerDescription: String {
        var result = ""
        
        result += "URL: \(url?.description ?? "Unknown")\n"
        result += "Status Code: \(statusCode)\n"
        
        result += "Headers: \n"
        result += allHeaderFields.map { "\t\($0): \($1)" }.sorted().joined(separator: "\n")
        
        return result
    }
}
