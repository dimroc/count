//
//  CyclingReplayProxy.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/23/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import RxSwift

// On completion of the passed observable, this proxy will replay the last
// n samples at the passed period interval in an infinite cycle.
class CyclingReplayProxy<T> {
    var observable: Observable<T> {
        return subject
    }

    var isEnabled = true

    private let subject = PublishSubject<T>()
    private let underlying = PublishSubject<T>()
    private let disposeBag = DisposeBag()
    private var cache: [T]
    private var cacheIndex = 0
    private var samples: Int

    init(observable: Observable<T>, period: TimeInterval, samples: Int) {
        self.cache = [T]()
        self.cache.reserveCapacity(samples)
        self.samples = samples

        let interval = Observable<Int>
            .interval(period, scheduler: SerialDispatchQueueScheduler(qos: .utility))
            .filter { _ in self.isEnabled }

        observable.subscribe(onNext: {
            self.underlying.onNext($0)
            self.cache.append($0)
        }, onCompleted: {
            print("Reverting to rolling cache")
            interval
                .subscribe(onNext: { _ in self.subject.onNext(self.nextSample()) })
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        Observable
            .zip(interval, underlying) { $1 }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .subscribe(onNext: { self.subject.onNext($0) })
            .disposed(by: disposeBag)
    }

    private func nextSample() -> T {
        let sample = cache[cacheIndex]
        cacheIndex = cacheIndex >= samples ? 0 : cacheIndex+1
        return sample
    }
}
