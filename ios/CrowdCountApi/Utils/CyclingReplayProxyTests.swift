//
//  CyclingReplayProxyTests.swift
//  CrowdCountTests
//
//  Created by Dimitri Roche on 8/1/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import XCTest
import RxSwift
@testable import CrowdCountApi

class CyclingReplayProxyTests: XCTestCase {
    func testObservable() {
        let stream = Observable.from(["one", "two", "three"])
        let pace = PublishSubject<Int>()
        let disposeBag = DisposeBag()
        var actual = [String]()

        let crp = CyclingReplayProxy(observable: stream, pace: pace, samples: 2)
        crp.observable.subscribe(onNext: {
            actual.append($0)
        }).disposed(by: disposeBag)

        pace.onNext(1)
        pace.onNext(1)
        pace.onNext(1)
        XCTAssertEqual(["one", "two", "three"], actual)

        pace.onNext(1)
        pace.onNext(1)
        pace.onNext(1)
        XCTAssertEqual(["one", "two", "three", "two", "three", "two"], actual)

        crp.isEnabled = false
        pace.onNext(1)
        XCTAssertEqual(["one", "two", "three", "two", "three", "two"], actual)
    }
}
