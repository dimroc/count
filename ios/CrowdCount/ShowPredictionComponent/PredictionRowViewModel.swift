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
import FirebaseStorage

struct PredictionRowViewModel {
    var classification: String
    var probability: Double
    var duration: Double
    var count: Double
    var insight: UIImage?

    static let empty = PredictionRowViewModel(
            classification: "unknown",
            probability: 0,
            duration: 0,
            count: 0,
            insight: nil)

    static func from(_ prediction: FriendlyPrediction, _ confidence: VNConfidence) -> PredictionRowViewModel {
        return PredictionRowViewModel(
            classification: prediction.name,
            probability: Double(confidence),
            duration: prediction.duration,
            count: prediction.count,
            insight: generateInsight(prediction))
    }

    static func from(realm: PredictionModel, insight: UIImage?) -> PredictionRowViewModel {
        return PredictionRowViewModel(
            classification: realm.classification,
            probability: realm.probability,
            duration: realm.duration,
            count: realm.count,
            insight: insight)
    }

    func upload(_ storageRef: StorageReference) {
        let imageRef = storageRef.child("\(classification).jpg")

        guard let data = insight?.jpegData(compressionQuality: 1) else {
            print("Unable to retrieve image data for upload")
            return
        }

        let metadata = StorageMetadata()
        metadata.customMetadata = [
            "classification": String(classification),
            "probability": String(probability),
            "duration": String(duration),
            "count": String(count),
        ]

        imageRef.putData(data, metadata: metadata)
    }
}

private func generateInsight(_ prediction: FriendlyPrediction) -> UIImage? {
    if prediction.name == "Singles" {
        return drawBoundingBoxes(prediction)
    }

    return prediction.densityMap.copy().normalize().image(offset: 0, scale: 255)
}

private func drawBoundingBoxes(_ prediction: FriendlyPrediction) -> UIImage? {
    guard let image = UIImage(cgImage: prediction.source).resizeImageFit(StyleGuide.thumbnailSize) else {
        print("Unable to create thumbnail for bounding boxes")
        return nil
    }

    let size = image.size
    let xfactor = size.width
    let yfactor = size.height

    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    let c = UIGraphicsGetCurrentContext()!
    c.setStrokeColor(UIColor.green.cgColor)
    c.setLineWidth(0.01 * size.width)

    for bb in prediction.boundingBoxes {
        let rect = CGRect(x: bb.minX * xfactor, y: size.height - bb.minY*yfactor, width: (bb.maxX-bb.minX)*xfactor, height: (bb.maxY-bb.minY) * -yfactor)
        c.stroke(rect)
    }
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return result!
}
