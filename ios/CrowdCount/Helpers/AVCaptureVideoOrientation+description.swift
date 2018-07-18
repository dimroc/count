//
//  AVCaptureVideoOrientation+description.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/17/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import AVFoundation

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
