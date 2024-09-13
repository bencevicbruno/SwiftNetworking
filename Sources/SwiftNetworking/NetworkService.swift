//
//  NetworkService.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation
import Combine

public final class NetworkService {
    
    private let configuration: NetworkServiceConfiguration
    private let session: URLSession = .shared
    
    public var requestInterceptors: [NetworkRequestInterceptor] = []
    
    public init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Completion Closures
    
    public func fetch(request: NetworkRequest, completion: @escaping NetworkRequestCallback<Void>) {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        perform(request: request) { result in
            dispatchQueue.async {
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func fetchData(request: NetworkRequest, completion: @escaping NetworkRequestCallback<Data>) {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        perform(request: request) { result in
            dispatchQueue.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func fetchJSON<T>(type: T.Type, request: NetworkRequest, decoder: JSONDecoder? = nil, completion: @escaping NetworkRequestCallback<T>) where T: Decodable {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        let decoder = decoder ?? self.configuration.jsonDecoder
        
        perform(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try decoder.decode(T.self, from: data)
                    dispatchQueue.async {
                        completion(.success(json))
                    }
                } catch {
                    dispatchQueue.async {
                        completion(.failure(.unableToDecodeDataAsJSON(data, error)))
                    }
                }
                
            case .failure(let error):
                dispatchQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func fetchString(request: NetworkRequest, encoding: String.Encoding = .utf8, completion: @escaping NetworkRequestCallback<String>) {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        perform(request: request) { result in
            switch result {
            case .success(let data):
                if let string = String(data: data, encoding: encoding) {
                    dispatchQueue.async {
                        completion(.success(string))
                    }
                } else {
                    dispatchQueue.async {
                        completion(.failure(.unableToDecodeDataAsString(data, encoding: encoding)))
                    }
                }
            case .failure(let error):
                dispatchQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Combine Publishers
    
    public func fetch(request: NetworkRequest) -> AnyPublisher<Void, NetworkServiceError> {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        return Deferred {
            Future { [weak self] promise in
                self?.fetch(request: request) { result in
                    switch result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: dispatchQueue)
        .eraseToAnyPublisher()
    }
    
    public func fetchData(request: NetworkRequest) -> AnyPublisher<Data, NetworkServiceError> {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        return Deferred {
            Future { [weak self] promise in
                self?.fetchData(request: request) { result in
                    switch result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: dispatchQueue)
        .eraseToAnyPublisher()
    }
    
    public func fetchJSON<T>(request: NetworkRequest, decoder: JSONDecoder? = nil) -> AnyPublisher<T, NetworkServiceError> where T: Decodable {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        return Deferred {
            Future { [weak self] promise in
                self?.fetchJSON(type: T.self, request: request, decoder: decoder) { result in
                    switch result {
                    case .success(let json):
                        promise(.success(json))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: dispatchQueue)
        .eraseToAnyPublisher()
    }
    
    public func fetchString(request: NetworkRequest, encoding: String.Encoding = .utf8) -> AnyPublisher<String, NetworkServiceError> {
        let requestResponseQoS = (request.responseQoS ?? configuration.responseQoS)
        let dispatchQueue = requestResponseQoS == .userInteractive ? DispatchQueue.main : DispatchQueue.global(qos: requestResponseQoS)
        
        return Deferred {
            Future { [weak self] promise in
                self?.fetchString(request: request, encoding: encoding) { result in
                    switch result {
                    case .success(let string):
                        promise(.success(string))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: dispatchQueue)
        .eraseToAnyPublisher()
    }
    
    // MARK: - Async Tasks
    
    public func fetch(request: NetworkRequest) async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.fetch(request: request) { result in
                continuation.resume(with: result)
            }
        }
        
        do {
            try Task.checkCancellation()
        } catch {
            throw NetworkServiceError.taskCancelled
        }
    }
    
    public func fetchData(request: NetworkRequest) async throws -> Data {
        let result = try await withCheckedThrowingContinuation { continuation in
            self.fetchData(request: request) { result in
                continuation.resume(with: result)
            }
        }
        
        do {
            try Task.checkCancellation()
        } catch {
            throw NetworkServiceError.taskCancelled
        }
        
        return result
    }
    
    public func fetchJSON<T>(request: NetworkRequest, decoder: JSONDecoder? = nil) async throws -> T where T: Decodable {
        let result: T = try await withCheckedThrowingContinuation { continuation in
            self.fetchJSON(type: T.self, request: request, decoder: decoder) { result in
                continuation.resume(with: result)
            }
        }
        
        do {
            try Task.checkCancellation()
        } catch {
            throw NetworkServiceError.taskCancelled
        }
        
        return result
    }
    
    public func fetchString(request: NetworkRequest, encoding: String.Encoding = .utf8) async throws -> String {
        let result = try await withCheckedThrowingContinuation { continuation in
            self.fetchString(request: request, encoding: encoding) { result in
                continuation.resume(with: result)
            }
        }
        
        do {
            try Task.checkCancellation()
        } catch {
            throw NetworkServiceError.taskCancelled
        }
        
        return result
    }
}

private extension NetworkService {
    
    // MARK: - Request Performing
    
    func perform(request: NetworkRequest, completion: @escaping NetworkRequestCallback<Data>) {
        var urlRequest: URLRequest
        
        do {
            urlRequest = try request.createURLRequest(using: configuration)
        } catch {
            completion(.failure(.unableToCreateRequest(error)))
            return
        }
        
        configuration.staticHeaders.forEach { header, value in
            urlRequest.addHeaderIfNotPresent(header: header, value)
        }
        
        do {
            try requestInterceptors.forEach {
                try $0.intercept(&urlRequest)
            }
        } catch {
            completion(.failure(.unableToInterceptRequest(error)))
        }
        
        configuration.logger?.log("========================================")
        configuration.logger?.log("⬆⬆⬆      Performing request.     ⬆⬆⬆")
        configuration.logger?.log("========================================")
        configuration.logger?.log()
        configuration.logger?.log(urlRequest)
        configuration.logger?.log("Body: \(request.bodyDescription(using: self.configuration))")
        configuration.logger?.log()
        
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let responseHandler = request.responseHandler ?? self.configuration.responseHandler
            responseHandler.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        .resume()
    }
}
