//
//  FriendlyPredictor+macos.swift
//  CrowdCountApiMac
//
//  Created by Dimitri Roche on 7/5/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import AppKit
import Foundation
import CoreImage

extension FriendlyPredictor {
    public func predict(image: NSImage) -> Double {
        let resized = image.resizeImage(CGSize(width: FriendlyPredictor.ImageWidth, height: FriendlyPredictor.ImageHeight))
        let buffer = resized.pixelBuffer(
            width: Int(FriendlyPredictor.ImageWidth),
            height: Int(FriendlyPredictor.ImageHeight)
        )
        return predict(buffer: buffer!)
    }
}
