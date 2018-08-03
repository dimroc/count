//
//  CameraViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/14/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import CrowdCountApi
import UIKit
import AVFoundation
import RxCocoa
import RxSwift

class CameraViewController: UIViewController {
    var frameExtractor: FrameExtractor!
    var classificationVM: ClassificationViewModel!
    var previewVM: PreviewViewModel!

    @IBOutlet var imageView: UIImageView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if Platform.isSimulator {
            frameExtractor = ImageFrameExtractor()
        } else {
            frameExtractor = CameraFrameExtractor()
        }

        frameExtractor.orientation = self.transformOrientation(UIDevice.current.orientation)
        classificationVM = ClassificationViewModel(frames: frameExtractor.frames)
        previewVM = PreviewViewModel(frames: frameExtractor.frames, classifications: classificationVM.classifications)

        driveFrames()

        let previewVC = PreviewViewController()
        addViewableChild(childController: previewVC)
        previewVC.drive(classifications: classificationVM.classifications, predictions: previewVM.predictions)

        let cameraButtonsVC = CameraButtonsViewController()
        addViewableChild(childController: cameraButtonsVC)
        cameraButtonsVC.drive(frames: frameExtractor.frames)
    }

    override func viewWillDisappear(_ animated: Bool) {
        frameExtractor.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        frameExtractor.isEnabled = true
    }

    private func driveFrames() {
        frameExtractor.frames
            .asDriver(onErrorJustReturn: UIImage())
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) -> Void in
            self.frameExtractor.orientation = self.transformOrientation(UIDevice.current.orientation)
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }

    private func transformOrientation(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight // TODO: Deliberately the opposite. Why? Not sure.
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }

}
