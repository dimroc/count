//
//  PredictionStrategy.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/6/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import CoreML

public protocol PredictionStrategy {
    func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput
}

extension PredictionStrategy {
    func FriendlyName() -> String {
        return String(describing: self)
            .replacingOccurrences(of: "CrowdCountApi.", with: "")
            .replacingOccurrences(of: "PredictionStrategy", with: "")
    }
}

public struct PredictionStrategyOutput {
    var density_map: MultiArray<Double>
}

public class SinglesPredictionStrategy: PredictionStrategy {
    let predictor = YOLO()
    let personClassIndex = 14
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let output = try! predictor.predict(image: buffer)
        print("singls prediction output:", output)
        let emptyShape = [1, FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]
        return PredictionStrategyOutput(density_map: MultiArray<Double>(shape: emptyShape))
    }
}

public class TensPredictionStrategy: PredictionStrategy {
    let predictor = TensPredictor()
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let input = TensPredictorInput(input_1: buffer)
        let output = try! self.predictor.prediction(input: input)
        return PredictionStrategyOutput(density_map: MultiArray<Double>(output.density_map))
    }
}

public class HundredsPredictionStrategy: PredictionStrategy {
    let predictor = HundredsPredictor()
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let input = HundredsPredictorInput(input_1: buffer)
        let output = try! self.predictor.prediction(input: input)
        return PredictionStrategyOutput(density_map: MultiArray<Double>(output.density_map))
    }
}
