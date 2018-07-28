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

class PredictionViewModel {
    var predictions: Observable<FriendlyPrediction> {
        return subject
    }

    private let predictor = FriendlyPredictor()
    private let semaphore = DispatchSemaphore(value: 1)
    private let subject = PublishSubject<FriendlyPrediction>()
    private let countingQueue = DispatchQueue(label: "prediction", qos: .userInitiated)
    private var threadUnsafeStrategyMap = [String: PredictionStrategy]()
    private let disposeBag = DisposeBag()

    init(frames: Observable<UIImage>, classifications: Observable<String>) {
        startPredicting(frames: frames, classifications: classifications)
    }

    private func startPredicting(frames: Observable<UIImage>, classifications: Observable<String>) {
        classifications
            .observeOn(SerialDispatchQueueScheduler(qos: .utility))
            .withLatestFrom(frames) { classification, image in return (classification, image) }
            .subscribe(onNext: { classification, image in self.skippingCounter(image: image, classification: classification) })
            .disposed(by: disposeBag)
    }

    private func skippingCounter(image: UIImage, classification: String) {
        if semaphore.wait(timeout: .now()) == .success {
            countingQueue.async { [unowned self] in
                defer { self.semaphore.signal() }
                guard let strategy = self.cachedStrategyFor(classification: classification) else {
                    print("Unable to discern strategy from \(classification)")
                    return
                }
                let prediction = self.predictor.predict(image: image, strategy: strategy)
                self.subject.onNext(prediction)
            }
        }
    }

    private func cachedStrategyFor(classification: String) -> PredictionStrategy? {
        if let strategy = threadUnsafeStrategyMap[classification] {
            return strategy
        } else {
            let strategy = PredictionStrategyFactory.from(classification: classification)
            threadUnsafeStrategyMap[classification] = strategy
            return strategy
        }
    }
}
