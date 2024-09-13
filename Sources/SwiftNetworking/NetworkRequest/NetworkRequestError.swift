//
//  File.swift
//
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public enum NetworkRequestError: Error {
    case invalidJPQQuality(quality: Float)
#if canImport(UIKit)
    case unableToEncodeMultipartImage(UIImage, encoding: UIImageEncoding)
#endif
    case unableToConstructURL(baseURL: String, path: String)
    case unableToConstructURL(baseURL: String, path: String, parameters: [String: String], NetworkRequestParameterEncoder)
    case unableToConstructURL(URLComponents)
}
