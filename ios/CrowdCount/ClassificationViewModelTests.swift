//
//  ClassificationViewModelTests.swift
//  CrowdCountTests
//
//  Created by Dimitri Roche on 8/1/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import XCTest
@testable import CrowdCount
import RxSwift

class ClassificationViewModelTests: XCTestCase {
    func testClassifications() {
        let disposeBag = DisposeBag()
        let frames = PublishSubject<UIImage>()
        let vm = ClassificationViewModel(frames: frames.asObservable())
        var receivedClassifications = [String]()
        let group = DispatchGroup()
        group.enter()

        vm.classifications.subscribe(onNext: {
            receivedClassifications.append($0)
            group.leave()
        }).disposed(by: disposeBag)

        XCTAssertEqual([], receivedClassifications)
        frames.onNext(UIImage())

        XCTAssertTrue(group.wait(timeout: .now() + 5) == .success, "Classification should have completed")
        XCTAssertEqual(["unknown"], receivedClassifications)

        group.enter()
        frames.onNext(UIImage(named: "audience-crowd-fans", in: Bundle.main, compatibleWith: nil)!)
        XCTAssertTrue(group.wait(timeout: .now() + 5) == .success, "Classification should have completed")
        XCTAssertEqual(["unknown", "hundreds_plus"], receivedClassifications)
    }
}
