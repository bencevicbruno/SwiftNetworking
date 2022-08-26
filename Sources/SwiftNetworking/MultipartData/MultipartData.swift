//
//  MultipartData.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

public struct MultipartData: Hashable {
    let name: String
    let fileName: String
    let mimeType: String
    let data: Data
    
    init(name: String, fileName: String, mimeType: String, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
