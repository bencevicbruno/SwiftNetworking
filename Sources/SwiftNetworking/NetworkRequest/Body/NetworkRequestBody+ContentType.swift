//
//  NetworkRequestBody+ContentType.swift
//
//
//  Created by Bruno Benčević on 21.03.2024..
//

import Foundation

public extension NetworkRequestBody {
    
    func getContentType(requestID: UUID) -> String? {
        switch self {
        case .raw:
            return nil
        case .multipart:
            return "multipart/form-data; boundary = \(requestID.uuidString)"
        case .formData:
            return "application/x-www-form-urlencoded"
        case .json:
            return "application/json"
        case .string:
            return nil
        }
    }
}
