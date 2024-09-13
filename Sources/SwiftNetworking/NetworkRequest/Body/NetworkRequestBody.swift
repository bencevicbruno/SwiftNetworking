//
//  NetworkRequestBody.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public enum NetworkRequestBody {
    case raw(Data)
    case multipart([MultipartData])
    case formData([String: String])
    case json(Encodable)
    case string(String, encoding: String.Encoding = .utf8)
}
