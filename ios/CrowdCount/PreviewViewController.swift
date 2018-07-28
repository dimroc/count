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

class PreviewViewController: UIViewController {
    var classificationLabel: UILabel!
    var countLabel: UILabel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        classificationLabel = createLabel()
        view.addSubview(classificationLabel)

        countLabel = createLabel()
        view.addSubview(countLabel)

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
    }

    func drive(classifications: Observable<String>, counts: Observable<Double>) {
        driveClassifications(classifications)
        driveCounts(counts)
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
            .drive(classificationLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func driveCounts(_ counts: Observable<Double>) {
        counts
            .map { String(format: "%.0f", $0) }
            .asDriver(onErrorJustReturn: "--")
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
