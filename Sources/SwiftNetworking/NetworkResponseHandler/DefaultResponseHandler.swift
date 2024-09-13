//
//  DefaultResponseHandler.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public struct DefaultResponseHandler: NetworkResponseHandler {
    
    private let logger: NetworkLogger?
    
    public init(logger: NetworkLogger? = nil) {
        self.logger = logger
    }
    
    public func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkRequestCallback<Data>) {
        logger?.log("=========================================")
        logger?.log("⬇⬇⬇       RESPONSE RECIEVED       ⬇⬇⬇")
        logger?.log("=========================================")
        logger?.log("")
        
        log(response: response)
        log(error: error)
        log(data: data)
        logger?.log("")
        logger?.log("")
        
        if let urlError = error as? URLError {
            if urlError.code == URLError.Code.notConnectedToInternet {
                completion(.failure(.noInternet))
                return
            }
            
            let code = urlError.code.rawValue
            
            switch code {
            case 100...199, 300...399:
                completion(.failure(.unhandledStatusCode(code)))
                return
            case 400...499:
                completion(.failure(.clientError(statusCode: code)))
                return
            case 500...599:
                completion(.failure(.serverError(statusCode: code)))
                return
            default:
                break
            }
        } else if let error {
            completion(.failure(.other(error)))
            return
        }
        
        if let response {
            if let response = response as? HTTPURLResponse {
                let code = response.statusCode
                
                switch code {
                case 100...199, 300...399:
                    completion(.failure(.unhandledStatusCode(code)))
                    return
                case 400...499:
                    completion(.failure(.clientError(statusCode: code)))
                    return
                case 500...599:
                    completion(.failure(.serverError(statusCode: code)))
                    return
                default:
                    break
                }
            } else {
                completion(.failure(.unknownResponse(response)))
                return
            }
        }
        
        completion(.success(data ?? Data()))
    }
}

private extension DefaultResponseHandler {
    
    func log(response: URLResponse?) {
        logger?.log("RESPONSE:")
        
        if let httpURLResponse = response as? HTTPURLResponse {
            logger?.log(httpURLResponse)
        } else {
            if let response  {
                logger?.log(response)
            } else {
                logger?.log("Empty")
            }
        }
    }
    
    func log(error: Error?) {
        guard let error = error else {
            return
        }
        
        logger?.log("ERROR:")
        
        if let error = error as? URLError {
            logger?.log(error)
        } else {
            logger?.log(error.localizedDescription)
        }
    }
    
    func log(data: Data?) {
        logger?.log("DATA:")
        
        guard let data = data else {
            logger?.log("Empty")
            return
        }
        
        if let utf8String = String(data: data, encoding: .utf8) {
            logger?.log(utf8String)
        } else {
            logger?.log("Raw (base 64): \(data.base64EncodedData())")
        }
    }
}
