//
//  URLResponse+NetworkLoggable.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension URLResponse: NetworkLoggable {
    
    @objc public var networkLoggerDescription: String {
        return self.description
    }
}
