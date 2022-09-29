//
//  File.swift
//  
//
//  Created by Bruno Benčević on 30.08.2022..
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    var urlSafe: Self {
        self.reduce(into: [:]) { result, pair in
            result[pair.key.urlSafe] = pair.value.urlSafe
        }
    }
}
