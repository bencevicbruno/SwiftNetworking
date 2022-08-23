//
//  UploadableData.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 22.08.2022..
//

import Foundation
import UIKit

struct UploadableData: Hashable {
    let name: String
    let fileName: String
    let mimeType: String
    let data: Data
}
