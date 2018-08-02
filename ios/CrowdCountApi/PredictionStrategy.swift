//
//  PredictionStrategy.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/6/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import CoreML
import Vision
import VideoToolbox

public protocol PredictionStrategy {
    func predict(_ cgImage: CGImage, orientation: CGImagePropertyOrientation) -> PredictionStrategyOutput
}

extension PredictionStrategy {
    public var friendlyName: String {
        return String(describing: self)
            .replacingOccurrences(of: "CrowdCountApi.", with: "")
            .replacingOccurrences(of: "PredictionStrategy", with: "")
    }

    fileprivate func predictWith(model: VNCoreMLModel, cgImage: CGImage, orientation: CGImagePropertyOrientation) -> PredictionStrategyOutput {
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .scaleFill

        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
        try! handler.perform([request])

        let observations = request.results as! [VNCoreMLFeatureValueObservation]
        guard let obs = observations.first else { return PredictionStrategyOutput.empty }
        return generateDensityMapOutput(obs.featureValue.multiArrayValue!)
    }
}

public class PredictionStrategyFactory {
    public static func from(classification: String) -> PredictionStrategy? {
        switch classification {
        case "Singles":
            return SinglesPredictionStrategy()
        case "Tens":
            return TensPredictionStrategy()
        case "Hundreds":
            return HundredsPredictionStrategy()
        default:
            return nil
        }
    }
}

public struct PredictionStrategyOutput {
    var densityMap: MultiArray<Double>
    var count: Double
    var boundingBoxes: [CGRect]
}

extension PredictionStrategyOutput {
    public static var empty: PredictionStrategyOutput {
        return PredictionStrategyOutput(
            densityMap: MultiArray<Double>(shape: [1, FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]),
            count: 0,
            boundingBoxes: [CGRect]()
        )
    }
}

public class SinglesPredictionStrategy: PredictionStrategy {
    let personClassIndex = 14
    public init() {}
    public func predict(_ cgImage: CGImage, orientation: CGImagePropertyOrientation) -> PredictionStrategyOutput {
        let boundingBoxes = FaceDetector.detect(within: cgImage, orientation: orientation)
        let emptyShape = [1, FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]
        return PredictionStrategyOutput(
            densityMap: MultiArray<Double>(shape: emptyShape),
            count: Double(boundingBoxes.count),
            boundingBoxes: boundingBoxes
        )
    }
}

public class TensPredictionStrategy: PredictionStrategy {
    let predictor = TensPredictor()
    let model: VNCoreMLModel
    public init() {
        model = try! VNCoreMLModel(for: predictor.model)
    }

    public func predict(_ cgImage: CGImage, orientation: CGImagePropertyOrientation) -> PredictionStrategyOutput {
        return self.predictWith(model: model, cgImage: cgImage, orientation: orientation)
    }
}

public class HundredsPredictionStrategy: PredictionStrategy {
    let predictor = HundredsPredictor()
    let model: VNCoreMLModel
    public init() {
        model = try! VNCoreMLModel(for: predictor.model)
    }

    public func predict(_ cgImage: CGImage, orientation: CGImagePropertyOrientation) -> PredictionStrategyOutput {
        return self.predictWith(model: model, cgImage: cgImage, orientation: orientation)
    }
}

func generateDensityMapOutput(_ densityMap: MLMultiArray) -> PredictionStrategyOutput {
    let ma = MultiArray<Double>(densityMap)
    return PredictionStrategyOutput(densityMap: ma, count: sum(ma), boundingBoxes: [CGRect]())
}

func sum(_ multiarray: MultiArray<Double>) -> Double {
    let rows = FriendlyPredictor.DensityMapHeight
    let cols = FriendlyPredictor.DensityMapWidth

    assert(multiarray.shape == [1, rows, cols])

    var sum: Double = 0
    for row in 0..<rows {
        for col in 0..<cols {
            sum += multiarray[0, row, col]
        }
    }
    return sum
}
