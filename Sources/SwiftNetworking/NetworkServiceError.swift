//
//  NetworkServicError.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public enum NetworkServiceError: Error {
    case noInternet
    case unknownResponse(URLResponse)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unhandledStatusCode(Int)
    case taskCancelled
    case other(Error)
    case unableToCreateRequest(Error)
    case unableToInterceptRequest(Error)
    case unableToDecodeDataAsJSON(Data, Error)
    case unableToDecodeDataAsString(Data, encoding: String.Encoding)
    case unableToEncodeStringAsData(String, encoding: String.Encoding)
    case unableToPercentEncodeString(String, encoding: CharacterSet)
    case notImplemented(message: String)
}

extension NetworkServiceError: Equatable {
    
    public static func == (lhs: NetworkServiceError, rhs: NetworkServiceError) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}
