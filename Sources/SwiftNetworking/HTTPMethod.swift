//
//  File.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

public enum HTTPMethod: String {
    /// Requests a representation of the specified resource. Used only to retrieve data.
    case GET
    /// Asks for a response indetical to a GET request, but without the response body.
    case HEAD
    /// Submits an entity to the specified resource, often causing a change in state or side effect on the server.
    case POST
    /// Replaces all current representations of the target resource with the request payload.
    case PUT
    /// Deletes the specified resource.
    case DELETE
    /// Establishes a tunnel to the server identified by the target resource.
    case CONNECT
    /// Describes the communication options for the target resource.
    case OPTIONS
    /// Performs a message loop-back test along the path to the target resource.
    case TRACE
    /// Applies partial modifications to a resource.
    case PATCH
}

extension HTTPMethod {
 
    init(_ httpMethod: HTTPMethodForMultipartData) {
        switch httpMethod {
        case .POST:
            self = .POST
        case .PUT:
            self = .PUT
        }
    }
    
    init(_ httpMethod: HTTPMethodForBodyParameters) {
        switch httpMethod {
        case .GET:
            self = .GET
        case .HEAD:
            self = .HEAD
        case .DELETE:
            self = .DELETE
        case .CONNECT:
            self = .CONNECT
        case .OPTIONS:
            self = .OPTIONS
        case .TRACE:
            self = .TRACE
        case .PATCH:
            self = .PATCH
        }
    }
}
