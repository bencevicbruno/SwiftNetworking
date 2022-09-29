//
//  HTTPMethodForMultipartData.swift
//  
//
//  Created by Bruno Benčević on 29.08.2022..
//

import Foundation

public enum HTTPMethodForMultipartData {
    /// Submits an entity to the specified resource, often causing a change in state or side effect on the server.
    case POST
    /// Replaces all current representations of the target resource with the request payload.
    case PUT
}
