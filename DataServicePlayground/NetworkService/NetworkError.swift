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
    case unableToEncodeRequestBodyAsJSON(Error)
    case unableToEncodeRequestBodyAsUTF8
    case noResponseData
    case badResponseJSON(Error)
}
