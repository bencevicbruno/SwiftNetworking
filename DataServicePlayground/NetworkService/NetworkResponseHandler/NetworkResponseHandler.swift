//
//  NetworkResponseHandler.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 16.08.2022..
//

import Foundation

protocol NetworkResponseHandler {
    
    func handleResponse<T>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping Callback<Result<T, Error>>) where T: Decodable
}
