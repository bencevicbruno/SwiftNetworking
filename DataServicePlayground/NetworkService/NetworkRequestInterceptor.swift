//
//  NetworkRequestInterceptor.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation

protocol NetworkRequestInterceptor {
    
    func intercept(_ request: inout NetworkRequest)
}
