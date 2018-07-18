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

class CameraViewController: UIViewController, FrameExtractorDelegate {
    var frameExtractor: FrameExtractor!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = CameraFrameExtractor()
        frameExtractor.delegate = self
    }
    
    func captured(image: UIImage) {
        imageView.image = image
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
