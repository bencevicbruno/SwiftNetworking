//
//  TypeAliases.swift
//  
//
//  Created by Bruno Bencevic on 03.02.2023..
//

import Foundation

public typealias NetworkRequestCallback<T> = (Result<T, NetworkServiceError>) -> Void
public typealias QoSClass = DispatchQoS.QoSClass;
