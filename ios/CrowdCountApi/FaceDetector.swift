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
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])
        do {
            try handler.perform([request])
        } catch let err as NSError {
            print("Failed to detect faces: \(err)")
            return []
        }
        guard let results = request.results else {
            return []
        }
        //swiftlint:disable:next force_cast
        let faces = results.filter { $0 is VNFaceObservation } as! [VNFaceObservation]
        return faces.map { $0.boundingBox }
    }
}
