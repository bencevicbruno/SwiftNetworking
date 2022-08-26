//
//  NetworkResponseHandler.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

public class NetworkResponseHandler {
    
    private let logger: NetworkLogger?
    
    private init(logger: NetworkLogger? = .consoleLogger) {
        self.logger = logger
    }
    
    func handleResponse<T>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping Callback<Result<T, Error>>) where T: Decodable {
        if let response = response as? HTTPURLResponse {
            logger?.log(response)
        }
        
        if let error = error {
            logger?.log(error)
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.noResponseData))
            return
        }
        logger?.log(String(decoding: data, as: UTF8.self))
        
        let t: T
        do {
            t = try JSONDecoder().decode(T.self, from: data)
        } catch {
            completion(.failure(NetworkError.badResponseJSON(error)))
            return
        }
        
        logger?.log("Body: \(t)")
        completion(.success(t))
    }
}

public extension NetworkResponseHandler {
    
    static var `default`: NetworkResponseHandler {
        NetworkResponseHandler(logger: NetworkLogger.consoleLogger)
    }
}

private extension NetworkResponseHandler {
    
    func log(_ message: String) {
        logger?.log(message)
    }
    
    func log(_ error: Error){
        logger?.log(error)
    }
    
    func log(_ loggable: NetworkLoggable) {
        logger?.log(loggable)
    }
}
