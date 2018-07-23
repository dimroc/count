//
//  ClassificationViewModel.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/19/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import CrowdCountApi

class ClassificationViewModel {
    var classifications: Driver<String> {
        return subject.asDriver(onErrorJustReturn: "Unknown")
    }

    private let predictor = FriendlyPredictor()
    private let semaphore = DispatchSemaphore(value: 1)
    private let subject = PublishSubject<String>()
    private let classificationQueue = DispatchQueue(label: "classifier", qos: .background)
    private let disposeBag = DisposeBag()

    init(frames: Observable<UIImage>) {
        startClassifying(frames: frames)
    }

    private func startClassifying(frames: Observable<UIImage>) {
        frames
            .throttle(1, scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "rx.classifier"))
            .subscribe(onNext: { self.skippingClassifier(image: $0) })
            .disposed(by: disposeBag)
    }

    private func skippingClassifier(image: UIImage) {
        if semaphore.wait(timeout: .now()) == .success {
            classificationQueue.async {
                let classification = self.predictor.classify(image: image).classification
                self.semaphore.signal()
                self.subject.onNext(classification)
            }
        }
    }
}
