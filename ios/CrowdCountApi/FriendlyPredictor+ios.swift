//
//  FriendlyPredictor+ios.swift
//  CrowdCountApiMac
//
//  Created by Dimitri Roche on 7/5/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import UIKit
import Promises
import Vision

extension FriendlyPredictor {
    public func predict(image: UIImage, strategy: PredictionStrategy) -> FriendlyPrediction {
        return predict(
            cgImage: image.cgImage!,
            orientation: CGImagePropertyOrientation(image.imageOrientation),
            strategy: strategy
        )
    }

    public func predictPromise(image: UIImage, strategy: PredictionStrategy) -> Promise<FriendlyPrediction> {
        return Promise {
            return self.predict(image: image, strategy: strategy)
        }
    }

    public func classify(image: UIImage) -> FriendlyClassification {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        return classify(image: image.cgImage!, orientation: orientation)
    }
}
