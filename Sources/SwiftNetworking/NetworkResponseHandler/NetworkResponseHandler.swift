//
//  NetworkResponseHandler.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public protocol NetworkResponseHandler {
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkRequestCallback<Data>)
}
