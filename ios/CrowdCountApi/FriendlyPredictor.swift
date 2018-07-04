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
    var predictor: TensPredictor!
    
    public init() {
        self.predictor = TensPredictor()
    }
    
    public func predict(image: UIImage) -> Double {
        let resized = image.resizeImage(CGSize(width: FriendlyPredictor.ImageWidth, height: FriendlyPredictor.ImageHeight))!
        let buffer = resized.pixelBuffer(
            width: Int(FriendlyPredictor.ImageWidth),
            height: Int(FriendlyPredictor.ImageHeight)
        )
        let input = TensPredictorInput(input_1: buffer!)
        let output = try! self.predictor.prediction(input: input)
        return sum(coreMLArray: output.density_map)
    }
    
    func sum(coreMLArray: MLMultiArray) -> Double {
        let rows = 168
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
