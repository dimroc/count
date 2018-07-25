//
//  CountingViewModel.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/25/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import CrowdCountApi

class CountViewModel {
    var counts: Observable<Double> {
        return subject
    }

    private let predictor = FriendlyPredictor()
    private let semaphore = DispatchSemaphore(value: 1)
    private let subject = PublishSubject<Double>()
    private let countingQueue = DispatchQueue(label: "count", qos: .userInitiated)
    private let disposeBag = DisposeBag()

    init(frames: Observable<UIImage>, classifications: Observable<String>) {
        startCounting(frames: frames, classifications: classifications)
    }

    private func startCounting(frames: Observable<UIImage>, classifications: Observable<String>) {
        classifications
            .withLatestFrom(frames) { classification, image in return (classification, image) }
            .subscribe(onNext: { classification, image in self.skippingCounter(image: image, classification: classification) })
            .disposed(by: disposeBag)
    }

    private func skippingCounter(image: UIImage, classification: String) {
        if semaphore.wait(timeout: .now()) == .success {
            countingQueue.async {
                defer { self.semaphore.signal() }
                guard let strategy = PredictionStrategyFactory.from(classification: classification) else {
                    return
                }
                let prediction = self.predictor.predict(image: image, strategy: strategy)
                self.subject.onNext(prediction.count)
            }
        }
    }
}
