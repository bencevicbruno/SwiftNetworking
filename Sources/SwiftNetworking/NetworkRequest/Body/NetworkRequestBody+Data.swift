//
//  NetworkRequestBody+Data.swift
//
//
//  Created by Bruno Benčević on 21.03.2024..
//

import Foundation

public extension NetworkRequestBody {
    
    func generateData(requestID: UUID, jsonEncoder: JSONEncoder) throws -> Data {
        switch self {
        case let .raw(data):
            return data
        case let .multipart(data):
            return try Self.generateMultipartBody(data, boundary: requestID)
        case let .formData(data):
            return try Self.generateFormDataBody(data)
        case let .json(data):
            return try jsonEncoder.encode(data)
        case let .string(string, encoding):
            return try string.encoded(using: encoding)
        }
    }
}

public extension NetworkRequestBody {
    
    // MARK: Utility - Body Generation
    
    static func generateMultipartBody(_ data: [MultipartData], boundary: UUID) throws -> Data {
        let boundary = boundary.uuidString
        var body = NSMutableData()
        
        for item in data {
            try body += "--\(boundary)" + .carriageReturnNewLine
            try body += "Content-Disposition: form-data; name=\"\(item.name)\""
            
            if let filename = item.fileName {
                try body += "; filename=\"\(filename)\""
            }
            
            try body += .carriageReturnNewLine
            
            if let contentType = item.mimeType {
                try body += "Content-Type: \(contentType)" + .carriageReturnNewLine
            }
            
            try body += .carriageReturnNewLine
            
            try body += item.getData()
            try body += .carriageReturnNewLine
        }
        
        try body += "--\(boundary)--"
        
        return body as Data
    }
    
    static func generateFormDataBody(_ data: [String: String]) throws -> Data {
        return try data
            .map { key, value in
                return key + "=" + value
            }
            .joined(separator: "&")
            .encoded(using: .utf8)
    }
    
    // MARK: Utility - Body Description
    
    static func getMultipartBodyDescription(_ data: [MultipartData], boundary: UUID) -> String {
        let boundary = boundary.uuidString
        var result = "Multipart:\n"
        
        for item in data {
            result += "--\(boundary)" + .carriageReturnNewLine
            result += "Content-Disposition: form-data; name=\"\(item.name)\""
            
            if let filename = item.fileName {
                result += "; filename=\"\(filename)\""
            }
            
            result += .carriageReturnNewLine
            
            if let contentType = item.mimeType {
                result += "Content-Type: \(contentType)" + .carriageReturnNewLine
            }
            
            result += .carriageReturnNewLine
            
            switch item {
            case let .parameter(_, value):
                result += value
#if canImport(UIKit)
            case let .image(_, _, encoding):
                result += "*RAW \(encoding) image data*"
#endif
            case let .file(_, fileType, _):
                result += "*RAW \(fileType) file data*"
            }
            
            result += .carriageReturnNewLine
        }
        
        result += "--\(boundary)--"
        
        return result
    }
    
    static func getFormDataBodyDescription(_ data: [String: String]) -> String {
        return "Form Data:\n\(data.map { $0 + "=" + $1 }.joined(separator: "&"))"
    }
}
