//
//  ContentView.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import SwiftUI
import Combine

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

struct ContentView: View {
    
//http://api.geonames.org/searchJSON?name_startsWith=\(urlSafePrefix)&maxRows=10&username=bencevic_bruno
    
    @State private var cancellables: Set<AnyCancellable> = []
    
    let networkService = NetworkService(configuration: .init(baseURL: "http://api.geonames.org", logger: ConsoleNetworkLogger.instance, sessionName: "TestNetwork"))
    
    @State private var text: String? = nil
    var body: some View {
        VStack {
            if let text = text {
                ScrollView(.vertical) {
                    Text(text)
                        .padding()
                }
            }
            
            Button("Perform Request") {
                performRequest()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
    
    func performRequest() {
        let request = NetworkRequest(path: "/searchJSON",
                                     parameters: ["name_startsWith" : "Brod",
                                                  "username": "bencevic_bruno"],
                                     httpMethod: .GET, resourceEncoding: .json)
        
        // Async Await
        Task {
            do {
                let result: GeoNamesResponse = try await networkService.perform(request: request)
                text = "\(result)"
            } catch {
                print(error)
            }
        }
        
        // Combine
//        networkService.performRequest(request)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    text = "\(error)"
//                case .finished:
//                    print("finished")
//                }
//            }, receiveValue: { (response: GeoNamesResponse) in
//                text = "\(response)"
//            })
//            .store(in: &cancellables)
        
        // Callback
//        networkService.performRequest(request) { (result: Result<GeoNamesResponse, Error>) in
//
//            text = "\(result)"
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
