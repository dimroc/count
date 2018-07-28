//
//  FriendlyPredictor.swift
//  CrowdCountApi
//
//  Created by Dimitri Roche on 6/29/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import CoreML
import Foundation
import Promises
import Vision

public class FriendlyPredictor {
    public static let ImageWidth: Double = 900
    public static let ImageHeight: Double = 675

    public static let DensityMapWidth: Int = 225
    public static let DensityMapHeight: Int = 168

    private let classifier = CrowdClassifier()
    private let classifierModel: VNCoreMLModel

    public init() {
        classifierModel = try! VNCoreMLModel(for: classifier.model)
    }

    public func predict(cgImage: CGImage, orientation: CGImagePropertyOrientation, strategy: PredictionStrategy) -> FriendlyPrediction {
        var output: PredictionStrategyOutput?
        let duration = Duration.measure(String(describing: strategy)) {
            output = strategy.predict(cgImage, orientation: orientation)
        }
        return FriendlyPrediction(
            name: strategy.friendlyName,
            count: output!.count,
            densityMap: output!.densityMap.reshaped([FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]),
            boundingBoxes: output!.boundingBoxes,
            duration: duration)
    }

    public func predictPromise(cgImage: CGImage, orientation: CGImagePropertyOrientation, strategy: PredictionStrategy) -> Promise<FriendlyPrediction> {
        return Promise {
            self.predict(cgImage: cgImage, orientation: orientation, strategy: strategy)
        }
    }

    public func classify(image: CGImage, orientation: CGImagePropertyOrientation) -> FriendlyClassification {
        return Duration.measureAndReturn("classify") {
            let request = VNCoreMLRequest(model: classifierModel)
            request.imageCropAndScaleOption = .scaleFill

            let handler = VNImageRequestHandler(cgImage: image, orientation: orientation)
            try! handler.perform([request])
            let classifications = request.results as! [VNClassificationObservation]

            return FriendlyClassification.from(classifications)
        }
    }

    public func classifyPromise(image: CGImage, orientation: CGImagePropertyOrientation, on: DispatchQueue) -> Promise<FriendlyClassification> {
        return Promise(on: on) {
            self.classify(image: image, orientation: orientation)
        }
    }
}

public struct FriendlyPrediction {
    public var name: String
    public var count: Double
    public var densityMap: MultiArray<Double>
    public var boundingBoxes: [CGRect]
    public var duration: Double
}

public struct FriendlyClassification {
    public var classification: String
    public var probabilities: [String: VNConfidence]

    public static func from(_ observations: [VNClassificationObservation]) -> FriendlyClassification {
        let probabilities = observations.reduce(into: [String: VNConfidence]()) { dict, o in
            dict[o.identifier] = o.confidence
        }
        return FriendlyClassification(
            classification: observations[0].identifier,
            probabilities: probabilities
        )

    }
}
