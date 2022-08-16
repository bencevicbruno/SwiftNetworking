//
//  NetworkService.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import Foundation
import Combine

typealias Callback<T> = (T) -> Void

final class NetworkService {
    
    private let configuration: NetworkServiceConfiguration
    private let session: URLSession = .shared
    
    private var requestInterceptors: [NetworkRequestInterceptor] = []
    
    init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
    }
}

// MARK: - Performing Requests
extension NetworkService {
    
    func perform<T>(request: NetworkRequest, completion: @escaping Callback<Result<T, Error>>) where T: Decodable {
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
    
    func perform<T>(request: NetworkRequest) -> AnyPublisher<T, Error> where T: Decodable {
        return Deferred { [weak self] in
            Future { [weak self] promise in
                guard let self = self else { return }
                
                self.perform(request: request) { (result: Result<T, Error>) in
                    switch result {
                    case .success(let t):
                        promise(.success(t))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                    
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func perform<T>(request: NetworkRequest) async throws -> T where T: Decodable {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            self.perform(request: request) { (result: Result<T, Error>) in
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
    
    func createURLRequest(_ networkRequest: NetworkRequest) -> Result<URLRequest, Error> {
        var request = networkRequest
        requestInterceptors.forEach { $0.intercept(&request) }
        
        guard var urlComponents = URLComponents(string: configuration.baseURL + request.path) else { return .failure(NetworkError.cantParseURL) }
        
        urlComponents.queryItems = request.parameters.map { .init(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return .failure(NetworkError.badURL) }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let body = request.body {
            switch request.resourceEncoding {
            case .json:
                do {
                    let data = try JSONSerialization.data(withJSONObject: body)
                    urlRequest.httpBody = data
                } catch {
                    return .failure(NetworkError.unableToEncodeRequestBodyAsJSON(error))
                }
            case .ulrEncoded:
                guard let data = body.map({ "\($0)=\($1)" }).joined(separator: "&").data(using: .utf8) else { return .failure(NetworkError.unableToEncodeRequestBodyAsUTF8) }
                urlRequest.httpBody = data
            }
        }
        
        return .success(urlRequest)
    }
}
