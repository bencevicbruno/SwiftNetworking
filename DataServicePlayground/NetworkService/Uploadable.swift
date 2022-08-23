//
//  Uploadable.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 22.08.2022..
//

import Foundation

struct UploadableData: Hashable {
    let uploadableFieldName: String
    let uploadableFileName: String
    let uploadableMimeType: String
    let uploadableData: Data
}
