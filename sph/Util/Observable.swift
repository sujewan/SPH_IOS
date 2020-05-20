//
//  Observable.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation

public final class Observable<T> {

    struct Observer<T> {
        weak var observer: AnyObject?
        let block: (T) -> Void
    }

    private var observers = [Observer<T>]()

    public var value: T {
        didSet { notifyObservers() }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func observe(on observer: AnyObject, observerBlock: @escaping (T) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        DispatchQueue.main.async { observerBlock(self.value) }
    }

    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    private func notifyObservers() {
        for observer in observers {
           DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}
