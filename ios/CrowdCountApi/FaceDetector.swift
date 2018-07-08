//
//  FaceDetector.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/7/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import Vision
import Promises

class FaceDetector {
    public static func detect(within cgimage: CGImage) -> [CGRect] {
        var boundingBoxes: [CGRect]?
        let request = VNDetectFaceRectanglesRequest { request, err in
            guard err == nil else {
                print(err!)
                return
            }
            
            guard let results = request.results else {
                return
            }
            
            let faces: [VNFaceObservation] = results.filter { $0 is VNFaceObservation } as! [VNFaceObservation]
            boundingBoxes = faces.map { $0.boundingBox }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])
        try! handler.perform([request])
        return boundingBoxes!
    }
}
