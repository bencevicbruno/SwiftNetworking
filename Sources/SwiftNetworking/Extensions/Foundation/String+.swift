//
//  String+.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

extension String {
    
    static var carriageReturnNewLine: String {
        "\r\n"
    }
    
    public static var notImplementedMessage: String {
        "Not implemented at the moment, oh well ¯\\_(ツ)_/¯"
    }
    
    func encoded(using encoding: Encoding) throws -> Data {
        if let data = self.data(using: encoding) {
            return data
        } else {
            throw NetworkServiceError.unableToEncodeStringAsData(self, encoding: encoding)
        }
    }
    
    func containsAny(_ strings: [String]) -> Bool {
        for s in strings {
            if self.contains(s) {
                return true
            }
        }
        
        return false
    }
}
