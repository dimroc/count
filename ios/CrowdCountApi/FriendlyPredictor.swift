//
//  FriendlyPredictor.swift
//  CrowdCountApi
//
//  Created by Dimitri Roche on 6/29/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import CoreML
import Foundation

public class FriendlyPredictor {
    public static let ImageWidth: Double = 900
    public static let ImageHeight: Double = 675
    
    public static let DensityMapWidth: Int = 225
    public static let DensityMapHeight: Int = 168
    
    public init() {}

    public func predict(buffer: CVPixelBuffer, strategy: PredictionStrategy) -> FriendlyPrediction {
        var output: PredictionStrategyOutput? = nil
        let duration = Duration.measure(String(describing: strategy)) {
            output = strategy.predict(buffer)
        }
        return FriendlyPrediction(
            name: strategy.FriendlyName(),
            count: sum(output!.density_map),
            density_map: output!.density_map.reshaped([FriendlyPredictor.DensityMapHeight, FriendlyPredictor.DensityMapWidth]),
            duration: duration)
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
}

public struct FriendlyPrediction {
    public var name: String
    public var count: Double
    public var density_map: MultiArray<Double>
    public var duration: Double
}
