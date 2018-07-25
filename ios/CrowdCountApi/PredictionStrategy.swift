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
    func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput
}

extension PredictionStrategy {
    public var friendlyName: String {
        return String(describing: self)
            .replacingOccurrences(of: "CrowdCountApi.", with: "")
            .replacingOccurrences(of: "PredictionStrategy", with: "")
    }
}

public class PredictionStrategyFactory {
    public static func from(classification: String) -> PredictionStrategy? {
        switch classification {
        case "singles":
            return SinglesPredictionStrategy()
        case "tens":
            return TensPredictionStrategy()
        case "hundreds_plus":
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

public class SinglesPredictionStrategy: PredictionStrategy {
    let personClassIndex = 14
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(buffer, options: nil, imageOut: &cgImage)
        let boundingBoxes = FaceDetector.detect(within: cgImage!)
        print("singles prediction bbs: ", boundingBoxes)
        print(String.init(describing: boundingBoxes))
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
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let input = TensPredictorInput(input_1: buffer)
        let output = try! self.predictor.prediction(input: input)
        return generateDensityMapOutput(output.density_map)
    }
}

public class HundredsPredictionStrategy: PredictionStrategy {
    let predictor = HundredsPredictor()
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let input = HundredsPredictorInput(input_1: buffer)
        let output = try! self.predictor.prediction(input: input)
        return generateDensityMapOutput(output.density_map)
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
