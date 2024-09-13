# Swift Networking

SwiftNetworking is a Swift package that provides utility functions for handling HTTP network requests. It was developed as a general solution for most cases iOS developers encountered over the years while also being as customizable as possible to suit everyones needs - from custom network requests, custom request body implementations to developer-provided encoding options for parameters.

## NetworkService

`NetworkService` is the class that handles all your requests. You can make requests that fetch raw `Data` objects, `String`s with different encoding types (defaulting to `UTF-8`) and `JSON` objects. You can also perform requests that return nothing.

3 types of asynchrounous programming are supported.
1. Completion Closures - when working with completion closures, use the `NetworkRequestCallback<T>` typealias (which is equivalent of writing `(Result<T, NetworkServiceError>) -> Void`).
2. Combine publishers
3. Async tasks - when working with async tasks, task cancellation is automatically checked.

When switching back to client code, the `responseQoS` provided in the configuration / request will be respected.

***NOTE: When working with async tasks, you have to deal with actor-switching by yourself. Annotating your functions or task bodies with `@MainActor` will suffice.***

### Examples of performing network requests using different methods (taken from SwiftNetworking tests).

Let's assume you have an instance of a network service and a generic request to make.
```swift
let networkService = NetworkService(configuration: .init(
    baseURL: "https://httpbin.org",
    sessionName: "HTTPBin"))

let genericRequest = NetworkRequest(path: "/get", method: .GET)
```

These are the ways you should perform your requests:
1. Completion Closures
   
```swift
func test_completionClosures() {
    networkService.fetchString(request: genericRequest) { result in
        switch result {
        case .success(let string):
            XCTAssert(true, "Request performed successfully: \(string)")
        case .failure(let error):
            XCTFail("Error performing generic request: \(error)")
        }
    }
}
```

2. Combine Publishers

```swift
var cancellable: AnyCancellable?

func test_combinePublisher() {
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
```

3. Async tasks
   
```swift
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
```

## Network Requests

The type you will be working the most is NetworkRequest. It has a lot of parameters so here is a quick rundown on each of them:
- `baseURL` *(optional)* - the baseURL of the requests. You usually do not pass anything here unless you want to override the baseURL provided in your network service's configuaration.
- `path` - the path of the endpoint
- `parameters` *(optional)* - the query parameters passed at the end of the constructed URL
- `parameterEncoding` *(optional)* - the way parameters are encoded in the URL. When default, the URL is constructed using Swift's URLComponents which uses the default encoding. When passing a custom parameter encoder, you are responsible for encoding parameters in a way that created a valid URL
- `method` - the HTTP method of the request
- `headers` *(optional)* - headers of the request. **These headers will overwrite any static headers provided in the network service's configuration or any headers that are automatically provided when creating the request's body that share the** ***same name***.
- `body` *(optional)* - the body of the request (see full explanation below)
- `responseQoS` *(optional)* - the quality of service / the thread the completion will be run on. If none is provided, the qos provided in the network service's configuartion is used.
- `responseHandler` *(optional)* - the response handler of the request. If none is provided, the response handler provided in the network service's configuartion is used.

### Examples

- generic request

![alt text](./Resources/url_example.png)
  
```swift
let request = NetworkRequest(baseURL: "https://www.somebackend.com", path: "/userdata/public/123", parameters: ["param": "value", "param2": "value2"], method: .GET,)
```

**NOTE: Preffer not using baseURL when creating NetworkRequests.**

- GET request - fetching data (from *REDACTED* tests)

```swift
func getAllJobs(tenantID: String) async throws -> [JobResponse] {
    let request = NetworkRequest(path: "/tenant/\(tenantID)/job",
                                  method: .GET)
    
    return try await networkService.fetchJSON(request: request)
}
```

- POST request - logging in (from *REDACTED* tests)

```swift
func login(email: String, password: String) async throws -> String {
    let request = NetworkRequest(path: "/rest/V1/integration/customer/token",
                                 method: .POST,
                                 body: .json([
                                    "username": email,
                                    "password": password
                                 ]))
    
    return try await String(networkService.fetchString(request: request)
        .dropFirst()
        .dropLast())
}
```

- POST request - uploading an image (from *REDACTED* tests)

```swift
func addPictureToJob(tenantID: String, jobID: String, image: UIImage) async throws -> PictureUploadResponse {
    let request = NetworkRequest(path: "/tenant/\(tenantID)/job/\(jobID)/picture",
                                  method: .POST,
                                  body: .multipart([
                                    .image(name: "uploadedFile",image: image, encoding: .jpg(quality: 0.8))
                                  ]))
    
    return try await networkService.fetchJSON(request: request)
}
```

- POST request - refreshing token (from *REDACTED* unit tests)

```swift
static func tokenRefresh(refreshToken: String) -> NetworkRequest {
    return .init(baseURL: "https://*REDACTED*gtidentity.azurewebsites.net",
                 path: "/connect/token",
                 method: .POST,
                 body: .formData([
                    "refresh_token": refreshToken,
                    "grant_type": "refresh_token",
                    "client_id": "inTOUCH4",
                    "client_secret": "NFIAOfrwjhr289u41!Ndo"
                 ]))
}
```

- PATCH request - controlling the Robolighno (from *REDACTED* unit tests)

```swift
static func robolihnoStateUpdate(name: String, state: *REDACTED*.RobolinhoState) -> NetworkRequest {
    return .init(path: "/v1/iot/things/\(name)/state/desired",
                 method: .PATCH,
                 body: .json([
                    "operationState": state.rawValue
                 ]))
}
``` 

### Request Body

This package comes with support for the most commonly used body types:
- `raw` - used when you have to provide raw data or custom-encoded body data
- `multipart` - used when uploading smaller files and images along with optional parameters. The `Content-Type` header is automatically set to `multipart/form-data; boundary = _requestID_`.
- `formData` - used when uploading data from forms (commonly used for registering/logging in). The `Content-Type` header is automatically set to `application/x-www-form-urlencoded`
- `json` - used when providing JSON files encoded by the default JSONEncoder. The `Content-Type` header is automatically set to `application/json`
- `string` - used when provoding strings with specified encoding

**NOTE: If you create a multipart body that contains only parameters, the body type will be automatically converted to formData.**

### Custom Network Requests

NetworkService was implemented to work on any kind of network request by requiring the request you pass to implement the `NetworkRequestProtocol`. One of the requirements of the protocol is to implement `func createURLRequest(using baseURL: String) throws -> URLRequest`. This function is used by the NetworkService to construct Swift's native type. It is your resposibility to make a valid request and to decide how errors should be handled when creating your requests.

## Network Service Configuration

Every NetworkService instance has to be provided with a NetworkServiceConfiguration object with the following parameters:
- `baseURL` - the URL that is prepended to every NetworkRequest's path (unless that same requests has specified another baseURL).
- `staticHeaders` *(optional)* - headers that are applied to all requests before being sent
- `logger` *(optional)* - a NetworkLogger implementation
- `sessionName` - used for internal purposes. You usually pass the name of your application / project.
- `responseHandler` *(optional)* - the response handler used for all incoming responses. Defaults to the DefaultResponseHandler if none is provided or to request-specific one if one is specified.
- `responseQoS` *(optional)* - the quality of service of the completion closure to be run on. Defaults to userInteractive *(which is equivalent to calling the completion on main thread)*
- `jsonDecoder` *(optional)* - an instance of JSON decoder to be used when fetching JSON files. Defaults to the default initialized JSONDecoder

## Interceptors

You can also intercept outgoing requests before actually being sent. To do so, create a class that implements the `NetworkRequestInterceptor` protocol. You have to implement one method: `func intercept(_ request: inout URLRequest) throws`.

If you do not want to intercept the passed request, you can early exit it using guards.

You can also throw errors if your app gets in an illegal states. For instance, on the AL-KO WatchOS app, when the user logs out of the app, the access token is deleted from user defaults which prevents the `AuthorizationInterceptor` from successfully intercepting the request. Another case where the interceptor fails is when the token is expired. Both errors can be thrown by this interceptor, which will propagate all the way to client code. Simply said, **you will be notified if any of your interceptors fail to intercept a request**.

AL-KO Example (`*REDACTED*Request` is a custom `NetworkRequestProtocol` implementation):

```swift
struct AuthorizationInterceptor: NetworkInterceptor {
    
    private let persistenceService = ServiceFactory.shared.persistenceService
    
    func intercept(_ request: inout *REDACTED*Request) throws {
        guard request.type != .token else { return }
        
        guard let token = persistenceService.token,
              let creationDate = persistenceService.tokenCreationDate else {
            throw NetworkError.noTokenFound
        }
        
        guard !token.isExpired(tokenCreationDate: creationDate) else {
            throw NetworkError.tokenExpired
        }
        
        request.headers["Authorization"] = "Bearer \(token.accessToken)"
    }
}
```

## Custom Response Handlers

When using SwiftNetworking, you are provided with a default implementation of NetworkResponseHandler which returns success if the status code is in range [200, 299]. For status codes in range [100, 199], [300, 399], [400, 499] and [500, 599], `unhandledStatusCode`, `clientError` and `serverError` are thrown respectivly. It also handles the `noInternet` error and `other` errors. This implementation handles almost all cases for projects we have worked on.

In case `DefaultResponseHandler` does not meet your requirements, you can create your own by creating a struct that implements the `NetworkResponseHandler` protocol which has one method requirement `func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkRequestCallback<Data>)`.

You can use your custom `NetworkResponseHandler` by setting it as the default response handler in `NetworkServiceConfiguration` or pass it to `NetworkRequest`'s init when constructing requests if it should be request-specific.

One example where `DefaultResponseHandler` would have to be modified is on *REDACTED* where some requests return with status code 204 which should be handled as an error. The recommended way to implement a custom `NetworkResponsehandler` is to copy the implementation of the `DefaultResponseHandler` and modify cases to suit your needs. For the previously mentiond *REDACTED* example, the implementation would go like this:

```swift
struct *REDACTED*ResponseHandler: NetworkResponseHandler {
    
    // ... constructor and properties...
    
    public func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkRequestCallback<Data>) {
        
        // ... error handling...
        
        if let response {
            if let response = response as? HTTPURLResponse {
                let code = response.statusCode
                
                switch code {
                case 100...199, 300...399:
                    completion(.failure(.unhandledStatusCode(code)))
                    return
                case 204:
                    completion(.failure(*REDACTED*Error.empty))
                    
        // ... other status codes handling
        
        completion(.success(data ?? Data()))
    }
}
```

## Network Logging

Debugging networking requests usually requires a lot of digging through the console. NetworkService comes with two types of NetworkLoggers: `ConsoleNetworkLogger` and `TimedNetworkLogger`, both of which will print errors, responses, data recieved an other information to the console. Both loggers are singletons.

You can create your custom NetworkLogger by implementing the `NetworkLogger` protocol which requires you to implement `func log(_ message: String)`
    and `func log(_ loggable: NetworkLoggable)`
    
If you wish to log your custom type in a different way than Swift prints it by default, implement the `NetworkLoggable` protocol on your type and `NetworkLogger`s will automatically pick your custom descriptions.

## Errors

When working with NetworkService, any errors that occur when creating or sending requests, recieving or decoding responses will be thrown. That means that all error handling is boiled down to you.

There are two custom types of errors that the NetworkService will throw: `NetworkServiceError`(which notifies you about failing status codes or internet connectivity issues and notifies you when creating a request fails). 

**NOTE: NetworkService will NEVER throw any other type of error other than `NetworkServiceError`. This means that you can force cast errors in catch blocks when making async-await network calls.**

# Tips & Tricks

## Network Service scope

Network service is a type of service that should outlive all network requests and be alive for the duration of your app's life. You can do so by using @Service propert wrapper and ServiceContainer, creating a singleton or using a service factory.

```swift
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
```

In the first example, right after you perform your request, your network service will go out of scope which will cause your response handler to go out of scope. Because of this, your completion handler will never be called. 

Things are different when working with async tasks. If you instantiate your network service inside the `Task`, it will live throughout it's whole lifetime. You will get the expected result, but it is highly discouraged to create a network service inside a task.

```swift
func example2() {
    Task {
        let networkService = NetworkService...
        let request = NetworkRequest...
        
        do {
            networkService.fetch(request)
        } catch {
            // handle errors
        }
    }
}
```

## Combine Publisher lifetime

Just like your network service, the variable you assign your publishers to must outlive the scope where it's been asigned. The following example won't work, as `cancellable` will immediatly be deallocated as it's the last expression in the function.

```swift
func example3() {
    let networkService = NetworkService...
    let request = NetworkRequest...
    
    let cancellable = networkService.fetch(request)
        .sink {
            // do your work here
        }
}
```

To prevent this, store your cancellables inside a `Set<AnyCancellable>` or assign them directly to a `AnyCancellable` variable.



## Avoiding double base URLs

When creating a network request, you have to follow its parameters' function.

Passing baseURL along with path to the `path` parameter will generate an invalid request. Passing the full url to the path and supplying a baseURL will create a valid URL, but in 99.9999999999999999% of the time you will get a URL that makes no sense and leads nowhere. SwiftNetworking logs everything you do to console so take an eye on it if you see your request generating an invalid URL.

Keep in mind if you pass a baseURL to a network request, it will ignore you network service's baseURL you specified in its configuration.
