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
    var densityMap: MultiArray<Double>
    var count: Double
    var boundingBoxes: [CGRect]
}

public class SinglesPredictionStrategy: PredictionStrategy {
    let predictor = YOLO()
    let personClassIndex = 14
    public init() {}
    public func predict(_ buffer: CVPixelBuffer) -> PredictionStrategyOutput {
        let output = try! predictor.predict(image: buffer)
        print("singles prediction output:", output)
        let persons = output.filter { $0.classIndex == personClassIndex }
        let emptyShape = [1, FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]
        return PredictionStrategyOutput(
            densityMap: MultiArray<Double>(shape: emptyShape),
            count: Double(persons.count),
            boundingBoxes: persons.map { $0.rect }
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
