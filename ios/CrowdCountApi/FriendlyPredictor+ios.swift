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

extension FriendlyPredictor {
    public func predict(image: UIImage, strategy: PredictionStrategy) -> FriendlyPrediction {
        let resized = image.resizeImage(CGSize(width: FriendlyPredictor.ImageWidth, height: FriendlyPredictor.ImageHeight))!
        let buffer = resized.pixelBuffer(
            width: Int(FriendlyPredictor.ImageWidth),
            height: Int(FriendlyPredictor.ImageHeight)
        )
        return predict(buffer: buffer!, strategy: strategy)
    }
    
    public func predictPromise(image: UIImage, strategy: PredictionStrategy) -> Promise<FriendlyPrediction> {
        return Promise {
            return self.predict(image: image, strategy: strategy)
        }
    }
}
