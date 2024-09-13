//
//  NSMutableData+.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension NSMutableData {
    
    static func +=(lhs: inout NSMutableData, rhs: Data) {
        lhs.append(rhs)
    }
    
    static func +=(lhs: inout NSMutableData, rhs: String) throws {
        if let data = rhs.data(using: .utf8) {
            lhs.append(data)
        } else {
            throw NetworkServiceError.unableToEncodeStringAsData(rhs, encoding: .utf8)
        }
    }
}
