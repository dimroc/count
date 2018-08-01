//
//  CrowdCountApiTests.swift
//  CrowdCountApiTests
//
//  Created by Dimitri Roche on 7/01/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import XCTest
@testable import CrowdCountApi

class CircularFifoQueueTests: XCTestCase {
    func testAsList() {
        let queue = CircularFifoQueue<Int>(capacity: 3)
        XCTAssertEqual([nil, nil, nil], queue.asList(), "Should be equal")

        queue.push(1)
        XCTAssertEqual([1, nil, nil], queue.asList(), "Should be equal")

        queue.push(2)
        queue.push(3)
        queue.push(4)
        XCTAssertEqual([4, 3, 2], queue.asList(), "Should be equal")
    }
}
