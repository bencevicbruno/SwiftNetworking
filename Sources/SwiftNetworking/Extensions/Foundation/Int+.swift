//
//  Int+.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension Int {
    
    var asTwoDigit: String {
        self > 10 ? "\(self)" : "0\(self)"
    }
}
