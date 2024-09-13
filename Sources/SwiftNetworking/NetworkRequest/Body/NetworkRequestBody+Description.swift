//
//  File.swift
//  
//
//  Created by Bruno Benčević on 21.03.2024..
//

import Foundation

public extension NetworkRequestBody {
    
    func getBodyDescription(requestID: UUID, jsonEncoder: JSONEncoder) -> String {
        switch self {
        case let .raw(data):
            return "Raw (base64):\n\(data.base64EncodedData())"
        case let .multipart(data):
            return Self.getMultipartBodyDescription(data, boundary: requestID)
        case let .formData(data):
            return Self.getFormDataBodyDescription(data)
        case let .json(data):
            guard let jsonData = try? jsonEncoder.encode(data) else { return "Error encoding JSON data." }
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return "Error converting JSON data to UTF-8 string." }
            
            return "JSON:\n\(jsonString)"
        case let .string(string, encoding):
            return "String (\(encoding)):\n\(string)"
        }
    }
}
