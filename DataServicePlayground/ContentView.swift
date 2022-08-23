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
    
    @StateObject var networkService = NetworkService(configuration: .init(baseURL: "http://api.geonames.org", logger: ConsoleNetworkLogger.instance, sessionName: "TestNetwork"))
    
    @State private var text: String? = nil
    @State private var searchText = ""
    
    init() {
    }
    
    var body: some View {
        VStack {
            Text("Network: \(networkService.isNetworkAvailable ? "Available" : "Unavailable")")
                .font(.bold(.headline)())
                .padding()
            
            if let text = text {
                ScrollView(.vertical) {
                    Text(text)
                        .padding()
                }.padding()
            } else {
                Spacer()
            }
                
            
            VStack {
                TextField("Insert Prefix", text: $searchText)
                    .frame(height: 60)
                    .background(Color.black.opacity(0.05))
                    .padding()
                
                Button("Perform Request") {
                    performRequest()
                }
                .padding()
                .buttonStyle(
                    .plain)
                .background(Color.blue)
                .padding()
            }
        }
        .foregroundColor(.black)
        .background(
            (networkService.isNetworkAvailable ? Color.green : Color.red).opacity(0.4)
        )
        .background(Color.white)
        .onAppear {
//            networkAvailable = networkService.isNetworkAvailable
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func performRequest() {
        var r = NetworkResource(path: "/searchJSON")
         let r1 = r.setParameters([
            "name_startsWith": searchText,
            "username": "bencevic_bruno"
        ])
        
//        let request = Resource(path: "/searchJSON",
//                                     parameters: ["name_startsWith" : searchText,
//                                                  "username": "bencevic_bruno"],
//                                     httpMethod: .GET)
        
        // Async Await
        Task {
            do {
                let result: GeoNamesResponse = try await networkService.perform(request: r1)
                text = Set(result.locations).sorted().joined(separator: "\n")
            } catch {
                print(error)
            }
        }
        
        // Combine
//        networkService.perform(request)
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
//
//        // Callback
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
