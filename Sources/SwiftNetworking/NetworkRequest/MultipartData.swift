//
//  MultipartData.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public enum MultipartData {
    
    case parameter(name: String, value: String)
    
#if canImport(UIKit)
    case image(name: String, image: UIImage, encoding: UIImageEncoding)
#endif
    
    case file(name: String, type: String, url: URL)
    
    var name: String {
        switch self {
        case let .parameter(name, _):
            return name
#if canImport(UIKit)
        case let .image(name, _, _):
            return name
#endif
        case let .file(name, _, _):
            return name
        }
    }
    
    var fileName: String? {
        switch self {
        case .parameter:
            return nil
#if canImport(UIKit)
        case let .image(name, _, encoding):
            return "\(name).\(encoding.fileExtension)"
#endif
        case let .file(name, type, _):
            return "\(name).\(type)"
        }
    }
    
    var mimeType: String? {
        switch self {
        case .parameter:
            return nil
#if canImport(UIKit)
        case let .image(_, _, encoding):
            return "image/\(encoding.fileExtension)"
#endif
        case let .file(_, type, _):
            return "file/\(type)"
        }
    }
    
    func getData() throws -> Data {
        switch self {
        case let .parameter(_, value):
            return try value.encoded(using: .utf8)
#if canImport(UIKit)
        case let .image(name, image, encoding):
            return try Self.getImageData(name: name, image: image, encoding: encoding)
#endif
        case let .file(name, type, url):
            return try Self.getFileData(name: name, type: type, url: url)
        }
    }
}

extension MultipartData {
    
    // MARK: Utility - Data Generation
    
#if canImport(UIKit)
    public static func getImageData(name: String, image: UIImage, encoding: UIImageEncoding) throws -> Data {
        let data: Data?
        
        switch encoding {
        case let .jpg(quality):
            if quality < 0.0 || quality > 1.0 {
                throw NetworkRequestError.invalidJPQQuality(quality: quality)
            }
            
            data = image.jpegData(compressionQuality: CGFloat(quality))
        case .png:
            data = image.pngData()
        }
        
        if let data {
            return data
        } else {
            throw NetworkRequestError.unableToEncodeMultipartImage(image, encoding: encoding)
        }
    }
#endif
    
    public static func getFileData(name: String, type: String, url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}
