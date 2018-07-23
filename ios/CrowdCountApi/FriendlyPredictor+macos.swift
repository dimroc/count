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
        return predict(buffer: imageToBuffer(image, width: Int(FriendlyPredictor.ImageWidth), height: Int(FriendlyPredictor.ImageHeight))!, strategy: strategy)
    }

    public func predictPromise(image: NSImage, strategy: PredictionStrategy) -> Promise<FriendlyPrediction> {
        return Promise {
            return self.predict(image: image, strategy: strategy)
        }
    }

    public func predictAllPromise(image: NSImage, on: DispatchQueue) -> Promise<[FriendlyPrediction]> {
        return all(on: on, [
            self.predictPromise(image: image, strategy: SinglesPredictionStrategy()),
            self.predictPromise(image: image, strategy: TensPredictionStrategy()),
            self.predictPromise(image: image, strategy: HundredsPredictionStrategy())
        ])
    }

    public func classifyPromise(image: NSImage, on: DispatchQueue) -> Promise<FriendlyClassification> {
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        return classifyPromise(image: cgImage, orientation: CGImagePropertyOrientation.right, on: on)
    }

    func imageToBuffer(_ image: NSImage, width: Int, height: Int) -> CVPixelBuffer? {
        let resized = image.resizeImage(CGSize(width: width, height: height))
        return resized.pixelBuffer(
            width: width,
            height: height
        )
    }
}
