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

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        classificationLabel = createLabel()
        view.addSubview(classificationLabel)

        countLabel = createLabel()
        view.addSubview(countLabel)

        durationLabel = createLabel()
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

    func drive(classifications: Observable<String>, predictions: Observable<FriendlyPrediction>) {
        driveClassifications(classifications)
        driveCounts(predictions)
        driveDurations(predictions)
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "System", size: 24)
        label.textColor = .white
        label.shadowColor = UIColor.darkGray
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.textAlignment = .center
        return label
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
}
