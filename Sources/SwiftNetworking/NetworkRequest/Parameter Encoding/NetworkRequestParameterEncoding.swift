//
//  NetworkRequestParameterEncoding.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public enum NetworkRequestParameterEncoding {
    case `default`
    case custom(NetworkRequestParameterEncoder)
}
