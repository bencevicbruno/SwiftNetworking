//
//  NetworkService.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation
import Combine
import Network

enum NetworkStatus {
    case available
    case unavailable(Error)
}

typealias Callback<T> = (T) -> Void
typealias NetworkCallback<T> = (Result<T, Error>) -> Void

final class NetworkService: ObservableObject {
    
    private let configuration: NetworkServiceConfiguration
    private let session: URLSession = .shared
    let availabilityQueue = DispatchQueue(label: "InternetAvailability")
    let monitor = NWPathMonitor()
    
    var requestInterceptors: [NetworkRequestInterceptor] = []
    
    @Published private(set) var isNetworkAvailable: Bool = false
    
    @Published var networkAvailability = PassthroughSubject<Bool, Never>()
    
    init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isAvailable = path.status == .satisfied
            print("Network available: \(isAvailable)")
            
            DispatchQueue.main.async {
                self.isNetworkAvailable = isAvailable
                self.networkAvailability.send(isAvailable)
            }
        }
        self.monitor.start(queue: availabilityQueue)
    }
}

// MARK: - Performing Requests
extension NetworkService {
    
    func fetch<T>(request: NetworkResource, completion: @escaping NetworkCallback<T>) where T: Decodable {
        performRequest(request) { [weak self] (result: Result<T, Error>) in
            guard let self = self else { return }
            
            let qos = request.handlerQoS ?? self.configuration.completionThread
            DispatchQueue.global(qos: qos).async {
                completion(result)
            }
        }
    }
    
    func fetch<T>(request: NetworkResource) -> AnyPublisher<T, Error> where T: Decodable {
        return Deferred { [weak self] in
            Future { [weak self] promise in
                guard let self = self else { return }
                
                self.performRequest(request) { (result: Result<T, Error>) in
                    switch result {
                    case .success(let t):
                        promise(.success(t))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.global(qos: request.handlerQoS ?? configuration.completionThread))
        .eraseToAnyPublisher()
    }
    
    func perform<T>(request: NetworkResource) async throws -> T where T: Decodable {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else {
                // TODO: - throw error
                return
            }
            
            self.performRequest(request) { (result: Result<T, Error>) in
                switch result {
                case .success(let t):
                    continuation.resume(returning: t)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

private extension NetworkService {
    
    func performRequest<T>(_ request: NetworkResource, completion: @escaping Callback<Result<T, Error>>) where T: Decodable {
        let urlRequestResult = createURLRequest(request)
        
        let urlRequest: URLRequest
        switch urlRequestResult {
        case .success(let request):
            urlRequest = request
        case .failure(let error):
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let responseHandler = request.responseHandler ?? self.configuration.responseHandler
            responseHandler.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        .resume()
    }
    
    func createURLRequest(_ networkRequest: NetworkResource) -> Result<URLRequest, Error> {
        var request = networkRequest
        requestInterceptors.forEach { $0.intercept(&request) }
        
        guard var urlComponents = URLComponents(string: configuration.baseURL + request.path) else { return .failure(NetworkError.cantParseURL) }
        
        urlComponents.queryItems = request.parameters.map { .init(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return .failure(NetworkError.badURL) }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.method.rawValue
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if !request.uploadables.isEmpty {
            let boundary = "Boundary-" + UUID().uuidString
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            do {
                request = request.setBody(try createURLRequestBody(uploadables: networkRequest.uploadables, boundary: boundary))
            } catch {
                return .failure(NetworkError.unableToCreateRequestBody(error))
            }
        }
        
        return .success(urlRequest)
    }
    
    func createURLRequestBody(uploadables: Set<UploadableData>, boundary: String) throws -> Data {
        let crlf = "\r\n"
        // add all types needed -- multipart form data
        let body = NSMutableData()
        
        for uploadable in uploadables {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"\(uploadable.uploadableFieldName)\"; filename=\"\(uploadable.uploadableFileName)\"\(crlf)")
            body.append("Content-Type: \(uploadable.uploadableMimeType)\r\n\r\n")
            body.append(uploadable.uploadableData)
            body.append(crlf)
        }
        
        
        if !uploadables.isEmpty {
            body.append("--\(boundary)--")
        }
        
        
        
        return body as Data
    }
}

extension NSMutableData {
    
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
