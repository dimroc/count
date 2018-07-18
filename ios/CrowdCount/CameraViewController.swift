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
    @IBOutlet var imageView: UIImageView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = CameraFrameExtractor()
        driveFrames()
    }
    
    private func driveFrames() {
        frameExtractor.frame
            .asDriver(onErrorJustReturn: UIImage())
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.frameExtractor.orientation = self.transformOrientation(UIDevice.current.orientation)
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func transformOrientation(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight // Deliberately the opposite. Why? Not sure.
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }

}
