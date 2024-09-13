//
//  NetworkRequestParameterEncoder.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public protocol NetworkRequestParameterEncoder {
    
    func encode(_ parameter: String) throws -> String
}
