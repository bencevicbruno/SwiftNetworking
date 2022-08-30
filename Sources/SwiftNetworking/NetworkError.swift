//
//  NetworkError.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

public enum NetworkError: Error {
    case cantParseURL
    case badURL
    case cantEndoceParametersInBodyasString
    case cantEndoceParametersInBodyasJSON
    case cantEncodeRequestBodyAsJSON(Error)
    case canEncodeRequestBodyAsUTF8
    case noResponseData
    case badResponseJSON(Error)
    case unableToCreateRequestBody(Error)
}

public extension Error {
    
    var isNoInternet: Bool {
        (self as? URLError)?.code == .notConnectedToInternet
    }
}
