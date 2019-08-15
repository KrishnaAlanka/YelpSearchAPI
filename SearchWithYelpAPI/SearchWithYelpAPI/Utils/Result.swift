//
//  Result.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
