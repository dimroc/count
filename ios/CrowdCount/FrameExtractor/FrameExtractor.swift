//
//  FrameExtractor.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/21/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

protocol FrameExtractor {
    var orientation: AVCaptureVideoOrientation { get set }
    var frames: Observable<UIImage> { get }
    var isEnabled: Bool { get set }
}
