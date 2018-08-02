//
//  PredictionRowViewModel.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/2/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Vision
import CrowdCountApi

struct PredictionRowViewModel {
    var classification: String
    var probability: Double
    var duration: Double
    var count: Double
    var insight: UIImage?

    static var empty: PredictionRowViewModel {
        return PredictionRowViewModel(
            classification: "unknown",
            probability: 0,
            duration: 0,
            count: 0,
            insight: nil)
    }

    static func from(_ prediction: FriendlyPrediction, _ confidence: VNConfidence) -> PredictionRowViewModel {
        return PredictionRowViewModel(
            classification: prediction.name,
            probability: Double(confidence),
            duration: prediction.duration,
            count: prediction.count,
            insight: generateInsight(prediction.densityMap, prediction.boundingBoxes, prediction.name))
    }
}

private func generateInsight(_ densityMap: MultiArray<Double>, _ boundingBoxes: [CGRect], _ name: String) -> UIImage? {
    if name == "Singles" {
        return drawBoundingBoxes(densityMap, boundingBoxes, name)
    }

    return densityMap.copy().normalize().image(offset: 0, scale: 255)
}

private func drawBoundingBoxes(_ densityMap: MultiArray<Double>, _ boundingBoxes: [CGRect], _ name: String) -> UIImage? {
    let size = CGSize(width: FriendlyPredictor.DensityMapWidth, height: FriendlyPredictor.DensityMapWidth)
    let xfactor = CGFloat(FriendlyPredictor.DensityMapWidth)
    let yfactor = CGFloat(FriendlyPredictor.DensityMapHeight)

    let image = UIImage()

    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    let c = UIGraphicsGetCurrentContext()!
    c.setFillColor(UIColor.black.cgColor)
    c.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    c.setStrokeColor(UIColor.white.cgColor)
    c.setLineWidth(0.01 * size.width)

    for bb in boundingBoxes {
        let rect = CGRect(x: bb.minX * xfactor, y: size.height - bb.minY*yfactor, width: (bb.maxX-bb.minX)*xfactor, height: (bb.maxY-bb.minY) * -yfactor)
        c.stroke(rect)
    }
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return result!
}
