//
//  AVCaptureVideoOrientation+description.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/17/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension AVCaptureVideoOrientation {
    public var description: String {
        switch self {
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        }
    }
}

extension UIDeviceOrientation {
    public var description: String {
        switch UIDevice.current.orientation {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "PortraitUpsideDown"
        case .landscapeLeft: return "LandscapeLeft"
        case .landscapeRight: return "LandscapeRight"
        case .faceUp: return "FaceUp"
        case .faceDown: return "FaceDown"
        case .unknown: return "Unknown"
        }
    }
}
