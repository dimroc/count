//
//  CircularFifoQueue.swift
//  CrowdCountApi
//
//  Created by Dimitri Roche on 7/28/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation

public class CircularFifoQueue<T> {
    public let capacity: Int
    private var list: [T?]
    private var writeIndex = 0

    public init(capacity: Int) {
        self.capacity = capacity
        list = [T?](repeating: nil, count: capacity)
    }

    // Pushes a new element to the front of the queue.
    public func push(_ t: T) {
        list[writeIndex % capacity] = t
        // Yes, I know it can overflow in hundreds of millions of years if run every ms.
        writeIndex += 1
    }

    public subscript(index: Int) -> T? {
        let readIndex = (writeIndex - index - 1) % capacity
        if readIndex < 0 || readIndex >= capacity {
            return nil
        }
        return list[readIndex]
    }

    public func asList() -> [T?] {
        var copy = [T?]()
        copy.reserveCapacity(capacity)
        for i in 0..<capacity {
            copy.append(self[i])
        }
        return copy
    }
}
