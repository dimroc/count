//
//  PreviewViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/28/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import CrowdCountApi

class PreviewViewController: UIViewController {
    var classificationLabel: UILabel!
    var countLabel: UILabel!
    var durationLabel: UILabel!

    var prevClassificationLabel: UILabel!
    var prevCountLabel: UILabel!
    var prevDurationLabel: UILabel!

    let previousPredictions = CircularFifoQueue<FriendlyPrediction>(capacity: 2)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        createCurrentPreview()
        createPreviousPreview()
    }

    private func createCurrentPreview() {
        classificationLabel = createLabel()
        countLabel = createLabel()
        durationLabel = createLabel()

        view.addSubview(classificationLabel)
        view.addSubview(countLabel)
        view.addSubview(durationLabel)

        classificationLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(classificationLabel) { cl in
            cl.top == cl.superview!.safeAreaLayoutGuide.top
            align(centerX: cl, cl.superview!)
        }

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(countLabel, classificationLabel) { count, classification in
            count.top == classification.bottom
            align(centerX: count, count.superview!)
        }

        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(durationLabel, countLabel) { duration, count in
            duration.top == count.bottom
            align(centerX: duration, duration.superview!)
        }
    }

    private func createPreviousPreview() {
        prevClassificationLabel = createSubtleLabel()
        prevCountLabel = createSubtleLabel()
        prevDurationLabel = createSubtleLabel()

        view.addSubview(prevClassificationLabel)
        view.addSubview(prevCountLabel)
        view.addSubview(prevDurationLabel)

        prevClassificationLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(prevClassificationLabel) { cl in
            cl.top == cl.superview!.safeAreaLayoutGuide.top
            cl.left == cl.superview!.safeAreaLayoutGuide.left
        }

        prevCountLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(prevCountLabel, prevClassificationLabel) { count, classification in
            count.top == classification.bottom
            count.left == count.superview!.safeAreaLayoutGuide.left
        }

        prevDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        constrain(prevDurationLabel, prevCountLabel) { duration, count in
            duration.top == count.bottom
            duration.left == duration.superview!.safeAreaLayoutGuide.left
        }
    }

    func drive(classifications: Observable<String>, predictions: Observable<FriendlyPrediction>) {
        driveClassifications(classifications)
        driveCounts(predictions)
        driveDurations(predictions)
        drivePreviousPrediction(predictions)
    }

    private func driveClassifications(_ classifications: Observable<String>) {
        classifications
            .asDriver(onErrorJustReturn: "Unknown")
            .map { "\($0.replacingOccurrences(of: "_", with: " ").capitalized) Strategy" }
            .drive(classificationLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func driveCounts(_ predictions: Observable<FriendlyPrediction>) {
        predictions
            .map { String(format: "%.0f people", $0.count) }
            .asDriver(onErrorJustReturn: "--")
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func driveDurations(_ predictions: Observable<FriendlyPrediction>) {
        predictions
            .map { String(format: "%.1f seconds", $0.duration) }
            .asDriver(onErrorJustReturn: "--")
            .drive(durationLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func drivePreviousPrediction(_ predictions: Observable<FriendlyPrediction>) {
        predictions
            .map { Optional($0) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { prediction in
                self.drivePreviousPrediction(prediction)
            })
            .disposed(by: disposeBag)
    }

    private func drivePreviousPrediction(_ optionalPrediction: FriendlyPrediction?) {
        guard let newPrediction = optionalPrediction else { return }
        previousPredictions.push(newPrediction)
        guard let prevPrediction = previousPredictions[1] else { return }

        prevClassificationLabel.text = prevPrediction.name
        prevCountLabel.text = String(format: "%.0f", prevPrediction.count)
        prevDurationLabel.text = String(format: "%.1fs", prevPrediction.duration)
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "--"
        label.h3().centerTextAlignment()
        return label
    }

    private func createSubtleLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.h4().centerTextAlignment()
        return label
    }
}
