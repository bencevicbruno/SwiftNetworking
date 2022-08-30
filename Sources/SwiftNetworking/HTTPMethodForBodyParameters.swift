//
//  HTTPMethodForBodyParameters.swift
//  
//
//  Created by Bruno Benčević on 29.08.2022..
//

import Foundation

public enum HTTPMethodForBodyParameters: String {
    /// Requests a representation of the specified resource. Used only to retrieve data.
    case GET
    /// Asks for a response indetical to a GET request, but without the response body.
    case HEAD
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
