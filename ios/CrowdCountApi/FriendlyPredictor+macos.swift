//
//  FriendlyPredictor+macos.swift
//  CrowdCountApiMac
//
//  Created by Dimitri Roche on 7/5/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import AppKit
import CoreImage
import Foundation
import Promises

extension FriendlyPredictor {
    public func predict(image: NSImage, strategy: PredictionStrategy) -> FriendlyPrediction {
        return predict(buffer: imageToBuffer(image)!, strategy: strategy)
    }
    
    public func predictPromise(image: NSImage, strategy: PredictionStrategy) -> Promise<FriendlyPrediction> {
        return Promise {
            return self.predict(image: image, strategy: strategy)
        }
    }

    public func predictAllPromise(image: NSImage, on: DispatchQueue) -> Promise<[FriendlyPrediction]> {
        return all(on: on, [
            self.predictPromise(image: image, strategy: TensPredictionStrategy()),
            self.predictPromise(image: image, strategy: HundredsPredictionStrategy())
        ])
    }
    
    public func classifyPromise(image: NSImage, on: DispatchQueue) -> Promise<FriendlyClassification> {
        return classifyPromise(buffer: imageToBuffer(image)!, on: on)
    }
    
    func imageToBuffer(_ image: NSImage) -> CVPixelBuffer? {
        let resized = image.resizeImage(CGSize(width: FriendlyPredictor.ImageWidth, height: FriendlyPredictor.ImageHeight))
        return resized.pixelBuffer(
            width: Int(FriendlyPredictor.ImageWidth),
            height: Int(FriendlyPredictor.ImageHeight)
        )
    }
}
