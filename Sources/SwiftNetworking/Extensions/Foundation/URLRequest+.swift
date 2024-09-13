//
//  URLRequest+.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension URLRequest {
    
    public func containsHeader(_ name: String) -> Bool {
        return self.value(forHTTPHeaderField: name) != nil
    }
    
    public mutating func addHeaderIfNotPresent(header: String, _ value: String) {
        guard !containsHeader(header) else { return }
        
        setValue(value, forHTTPHeaderField: header)
    }
}
