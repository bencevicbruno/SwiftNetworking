//
//  UIImageEncoding.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public enum UIImageEncoding {
    case jpg(quality: Float)
    case png
    
    var fileExtension: String {
        switch self {
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        }
    }
}
