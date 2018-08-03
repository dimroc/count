//
//  ShutterButtonViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/29/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class CameraButtonsViewController: UIViewController {
    let shutterButton = ShutterButton()
    let constraintGroup = ConstraintGroup()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(shutterButton)
        setConstraints()
    }

    func drive(frames: Observable<UIImage>) {
        shutterButton.rx.tap
            .withLatestFrom(frames) { _, frame in return frame }
            .subscribe(onNext: { image in
                NotificationCenter.default.post(name: .navigateToShowPrediction, object: image)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraints()
        super.viewWillTransition(to: size, with: coordinator)
    }

    private func setConstraints() {
        let pageControlOffset: CGFloat = -40
        constrain(shutterButton, replace: constraintGroup) { sb in
            if UIDevice.current.orientation.isLandscape {
                sb.right == sb.superview!.safeAreaLayoutGuide.right + pageControlOffset
                align(centerY: sb, sb.superview!)
            } else {
                sb.bottom == sb.superview!.safeAreaLayoutGuide.bottom + pageControlOffset
                align(centerX: sb, sb.superview!)
            }
        }
    }
}
