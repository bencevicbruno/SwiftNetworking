//
//  TypeAliases.swift
//  
//
//  Created by Bruno Benčević on 24.08.2022..
//

import Foundation

public typealias Callback<T> = (T) -> Void
public typealias NetworkCallback<T> = (Result<T, Error>) -> Void
