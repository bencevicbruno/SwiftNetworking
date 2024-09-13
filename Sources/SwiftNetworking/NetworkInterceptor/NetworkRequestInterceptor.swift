//
//  NetworkRequestInterceptor.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public protocol NetworkRequestInterceptor {
    
    func intercept(_ request: inout URLRequest) throws
}
