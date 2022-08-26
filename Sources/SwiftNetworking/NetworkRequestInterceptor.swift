//
//  NetworkRequestInterceptor.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

protocol NetworkRequestInterceptor {
    
    func intercept(_ request: inout NetworkRequest)
}
