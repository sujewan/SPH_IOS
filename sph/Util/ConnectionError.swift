//
//  ConnectionError.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
