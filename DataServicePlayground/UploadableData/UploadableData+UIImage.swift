//
//  UploadableData+UIImage.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 23.08.2022..
//

import UIKit

extension UploadableData {
    
    init?(_ uiImage: UIImage, name: String = "image", format: ImageFormat) {
        guard let data = format.getData(from: uiImage) else { return nil }
        self.name = "\(name)"
        self.fileName = "\(name).\(format.extension)"
        self.mimeType = "image/\(format.extension)"
        self.data = data
    }
    
    enum ImageFormat {
        case jpeg(CGFloat)
        case png
        
        func getData(from image: UIImage) -> Data? {
            switch self {
            case .jpeg(let quality):
                return image.jpegData(compressionQuality: quality)
            case .png:
                return image.pngData()
            }
        }
        
        var `extension`: String {
            switch self {
            case .jpeg:
                return "jpeg"
            case .png:
                return "png"
            }
        }
    }
}
