//
//  GeonamesView.swift
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

struct GeonamesView: View {
    
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func performRequest() {
        let resource = NetworkResource("/searchJSON",
        parameters: [
            "name_startsWith": searchText,
            "username": "bencevic_bruno"
        ])
        
        performAsyncAwait(resource)
    }
    
    func performAsyncAwait(_ resource: NetworkResource) {
        Task {
            do {
                let response: GeoNamesResponse = try await networkService.fetch(resource)
                text = Set(response.locations).sorted().joined(separator: "\n")
            } catch {
                print(error)
            }
        }
    }
    
    func performCombine(_ resource: NetworkResource) {
        networkService.fetch(resource)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    text = "\(error)"
                case .finished:
                    print("finished")
                }
            }, receiveValue: { (response: GeoNamesResponse) in
                text = Set(response.locations).sorted().joined(separator: "\n")
            })
            .store(in: &cancellables)
    }
    
    func perfomCompletion(_ resource: NetworkResource) {
        networkService.fetch(resource) { (result: Result<GeoNamesResponse, Error>) in
            switch result {
            case .success(let response):
                self.text = Set(response.locations).sorted().joined(separator: "\n")
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct GeonamesView_Previews: PreviewProvider {
    static var previews: some View {
        GeonamesView()
    }
}
