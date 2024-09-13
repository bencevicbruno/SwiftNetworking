//
//  AsyncTests.swift.swift
//  
//
//  Created by Bruno Bencevic on 21.03.2023..
//

import XCTest
import Combine
@testable import SwiftNetworking

final class AsyncTests: XCTestCase {
    
    let networkService = NetworkService(configuration: .init(
        baseURL: "https://httpbin.org",
        logger: ConsoleNetworkLogger.instance,
        sessionName: "HTTPBin"))
    
    let genericRequest = NetworkRequest(path: "/get", method: .GET)
    
    func test_completionClosures() {
        struct Response: Decodable {}
        
        networkService.fetchJSON(type: Response.self, request: genericRequest) { result in
            switch result {
            case .success(let json):
                XCTAssert(true, "Request performed successfully: \(json)")
            case .failure(let error):
                XCTFail("Error performing generic request: \(error)")
            }
        }
    }
    
    var cancellable: AnyCancellable?
    
    func test_combinePublisher() {
        let logger: NetworkLogger = .timed
        
        cancellable = networkService.fetchString(request: genericRequest)
            .sink(receiveCompletion: { a in
                switch a {
                case .finished:
                    print("Request performed successfully:")
                case .failure(let error):
                    XCTFail("Error performing generic request: \(error)")
                }
            }, receiveValue: { string in
                XCTAssert(true, string)
            })
    }
    
    func test_asyncTask() {
        Task {
            do {
                let string = try await networkService.fetchString(request: genericRequest)
                XCTAssert(true, "Request performed successfully: \(string)")
            } catch {
                XCTFail("Error performing generic request: \(error)")
            }
        }
    }
}
