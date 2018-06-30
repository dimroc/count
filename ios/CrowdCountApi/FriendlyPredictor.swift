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
    
    public func predict(imagePath: String) -> Double {
        let image = UIImage(contentsOfFile: imagePath)!
        let buffer = image.pixelBuffer(width: 900, height: 600)
        let input = CrowdPredictorInput(input_1: buffer!)
        let output = try! self.predictor.prediction(input: input)
        return sum(multiarray: output.density_map)
    }
    
    func sum(multiarray: MLMultiArray) -> Double {
        return 5 // todo
    }
}
