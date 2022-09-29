//
//  String+.swift
//  
//
//  Created by Bruno Benčević on 23.08.2022..
//

import Foundation

extension String {
    
    static var carriageReturnNewLine: String {
        "\r\n"
    }
    
    var urlSafe: Self {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
