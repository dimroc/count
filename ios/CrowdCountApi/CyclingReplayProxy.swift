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
public class CyclingReplayProxy<T> {
    public var observable: Observable<T> {
        return subject
    }

    public var isEnabled = true

    private let subject = PublishSubject<T>()
    private let disposeBag = DisposeBag()
    private var cache: CircularFifoQueue<T>
    private var cacheIndex = 0

    // Constructs a proxy that will pass through everything from observable at the
    // passed pace (interval Observable<int> or period), and then upon completion of observable, will replay
    // the last samples in an infinite loop at the same pace.
    public init(observable: Observable<T>, pace: Observable<Int>, samples: Int) {
        self.cache = CircularFifoQueue<T>(capacity: samples)
        let interval = pace.filter { _ in self.isEnabled }

        cache(observable)
        proxyThenReplay(observable, interval: interval)
    }

    private func cache(_ observable: Observable<T>) {
        observable.subscribe(onNext: { self.cache.push($0) }).disposed(by: disposeBag)
    }

    private func proxyThenReplay(_ observable: Observable<T>, interval: Observable<Int>) {
        Observable
            .zip(interval, observable) { $1 }
            .subscribe(onNext: {
                self.subject.onNext($0)
            }, onCompleted: {
                print("Reverting to rolling cache")
                // onComplete takes an element from interval to fire, make up for it.
                self.subject.onNext(self.nextSample())
                interval
                    .subscribe(onNext: { _ in self.subject.onNext(self.nextSample()) })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }

    private func nextSample() -> T {
        // On replay, play in same order, from front to back, so reverse index
        let sample = cache[cache.capacity - cacheIndex - 1]
        cacheIndex = cacheIndex >= cache.capacity ? 0 : cacheIndex+1
        return sample!
    }
}
