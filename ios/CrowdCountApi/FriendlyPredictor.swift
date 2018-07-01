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
    var predictor: CrowdPredictor!
    
    public init() {
        self.predictor = CrowdPredictor()
    }
    
    public func predict(image: UIImage) -> Double {
        let buffer = image.pixelBuffer(width: 900, height: 600)
        let input = CrowdPredictorInput(input_1: buffer!)
        let output = try! self.predictor.prediction(input: input)
        return sum(coreMLArray: output.density_map)
    }
    
    func sum(coreMLArray: MLMultiArray) -> Double {
        let rows = 150
        let cols = 225
        
        var multiarray = MultiArray<Double>(coreMLArray)
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
