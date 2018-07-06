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

public struct PredictionStrategyOutput {
    var density_map: MultiArray<Double>
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
