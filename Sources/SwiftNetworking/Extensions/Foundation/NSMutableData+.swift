//
//  NSMutableData+.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

extension NSMutableData {
    
    static func +=(lhs: inout NSMutableData, rhs: Data) {
        lhs.append(rhs)
    }
    
    static func +=(lhs: inout NSMutableData, rhs: String) {
        if let data = rhs.data(using: .utf8) {
            lhs.append(data)
        }
    }
}
