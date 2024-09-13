//
//  HTTPBin.swift
//  
//
//  Created by Bruno Bencevic on 20.03.2023..
//

import XCTest
@testable import SwiftNetworking

final class HTTPBin: XCTestCase {
    
    let networkService = NetworkService(configuration:
            .init(baseURL: "https://httpbin.org",
                  sessionName: "HTTPBin"))
    
    func test_postMethod() async throws {
        let string = try await networkService.fetchString(request: NetworkRequest(path: "/post", method: .POST, responseQoS: nil))
        XCTAssert(!string.isEmpty)
        
        do {
            let _ = try await networkService.fetchString(request: NetworkRequest(path: "/post", method: .GET, responseQoS: nil))
        } catch {
            let error = error as! NetworkServiceError
            XCTAssert(error == .clientError(statusCode: 405))
        }
    }
}
