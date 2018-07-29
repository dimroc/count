//
//  CrowdCountApiTests.swift
//  CrowdCountApiTests
//
//  Created by Dimitri Roche on 6/27/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import XCTest
@testable import CrowdCountApi

class CrowdCountApiTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCircularFifoQueue() {
        let queue = CircularFifoQueue<Int>(capacity: 3)
        queue.push(1)
        queue.push(2)
        queue.push(3)
        queue.push(4)

        XCTAssertEqual([4, 3, 2], queue.asList(), "Should be equal")
    }

}
