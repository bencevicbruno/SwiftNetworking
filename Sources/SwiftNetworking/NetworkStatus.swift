//
//  NetworkStatus.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

enum NetworkStatus {
    case available
    case unavailable(Error?)
}
