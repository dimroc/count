//
//  PredictorTests.swift
//  crowdcountTests
//
//  Created by Dimitri Roche on 6/16/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import XCTest
@testable import Runner

class PredictorTests: XCTestCase {
    var model: Predictor!
    
    override func setUp() {
        model = Predictor()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(model.predict(input: 5) == 5)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            model.predict(input: 5)
        }
    }
    
}
