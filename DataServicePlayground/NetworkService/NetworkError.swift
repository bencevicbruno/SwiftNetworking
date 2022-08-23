//
//  NetworkError.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation

enum NetworkError: Error {
    case cantParseURL
    case badURL
    case cantEncodeRequestBodyAsJSON(Error)
    case canEncodeRequestBodyAsUTF8
    case noResponseData
    case badResponseJSON(Error)
    case unableToCreateRequestBody(Error)
}

extension Error {
    
    var isNoInternet: Bool {
        (self as? URLError)?.code == .notConnectedToInternet
    }
}
