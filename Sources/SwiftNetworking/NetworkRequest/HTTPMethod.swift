//
//  HTTPMethod.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

/**
 The HTTP request method.
 */
public enum HTTPMethod: Equatable {
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
    /// Used in case non of the builtin cases satisfy given requirements
    case OTHER(_ name: String)
    
    var supportsUpload: Bool {
        return self == .POST || self == .PUT || self == .PATCH
    }
    
    var name: String {
        return switch self {
        case let .OTHER(name): name
        default: "\(self)"
        }
    }
}
