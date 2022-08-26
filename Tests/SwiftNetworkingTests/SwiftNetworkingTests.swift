import XCTest
@testable import SwiftNetworking

struct GeoNamesResponse: Codable {
    let geonames: [City]
    
    var locations: [String] {
        Array(Set(geonames.map { $0.name })).sorted()
    }
}

extension GeoNamesResponse {
    
    struct City: Codable {
        let name: String
    }
}

final class SwiftNetworkingTests: XCTestCase {
    
    func testRequest() throws {
        test2()
    }
    
    private func test1() {
        print("Performing 1st test")
        let networkService = NetworkService(configuration: .init(baseURL: "http://api.geonames.org",
                                                                 logger: .consoleLogger,
                                                                 sessionName: "TestNetwork"))
        let resource = NetworkRequest("/searchJSON",
                                      parameters: [
                                        "name_startsWith": "brod",
                                        "username": "bencevic_bruno"
                                      ])
        
        Task {
            do {
                let response: GeoNamesResponse = try await networkService.fetch(resource)
                print(response)
            
                XCTAssertFalse(response.locations.isEmpty)
            } catch {
                print(error)
                XCTAssertNotNil(error)
            }
        }
    }
    
    private func test2() {
//        guard let data = MultipartData(UIImage(), format: .png) else {
//            XCTAssertTrue(false)
//            return
//        }
        let data = MultipartData(name: "hehe", fileName: "yes", mimeType: "text", data: "hahahahahahxdlollolol".data(using: .utf8)!)
        let networkService = NetworkService(configuration: .init(baseURL: "https://httpbin.org",
                                                                 logger: .consoleLogger,
                                                                 sessionName: "TestNetwork"))
        let request = NetworkRequest("/post",
                                     method: .POST,
                                     multipartData: data)
        
        print("uploading")
        Task {
            do {
                let response: String = try await networkService.fetch(request)
                print(response)
            } catch let error {
                print(error)
            }
        }
        
        XCTAssertTrue(true)
    }
}
