//
//  RepositoryTask.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation

public protocol NetworkCancellable {
    func cancel()
}

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
