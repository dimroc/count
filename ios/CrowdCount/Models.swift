//
//  PredictionModel.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/3/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class PredictionAnalysisModel: Object {
    // Matches classification labels from CrowdClassifier.mlmodel
    enum ImageLabel: String {
        case original = "Original"
        case singles = "Singles"
        case tens = "Tens"
        case hundreds = "Hundreds"
    }

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var createdAt: Date?
    let predictions = List<PredictionModel>()

    override static func primaryKey() -> String? {
        return "id"
    }

    static func from(_ image: UIImage, predictions: [PredictionRowViewModel]) -> PredictionAnalysisModel {
        let pam = PredictionAnalysisModel()
        pam.createdAt = Date()
        pam.predictions.append(objectsIn: predictions.map { PredictionModel.from($0) })
        pam.write(image: image, predictions: predictions)
        return pam
    }

    func image(for label: ImageLabel) -> UIImage? {
        let path = folder.appendingPathComponent("\(label.rawValue).jpg")
        guard let data = try? Data(contentsOf: path) else {
            print("Unable to load \(id):\(label.rawValue) from \(path)")
            return nil
        }
        return UIImage(data: data)
    }

    private func write(image: UIImage, predictions: [PredictionRowViewModel]) {
        print("Writing prediction analysis \(id) to \(folder)")
        try! FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        var dicts = Dictionary(uniqueKeysWithValues: predictions.map { ($0.classification, $0.insight) })
        dicts[ImageLabel.original.rawValue] = image

        for (label, image) in dicts {
            guard let data = image?.jpegData(compressionQuality: 1) else {
                print("Unable to retrieve image data for \(label) on \(id)")
                continue
            }
            write(label, data: data)
        }
    }

    private func write(_ label: String, data: Data) {
        let dst = folder.appendingPathComponent("\(label).jpg")
        if (try? data.write(to: dst, options: .atomic)) == nil {
            print("Unable to write data for \(label) on prediction analysis \(id)")
        }
    }

    private var folder: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
            .appendingPathComponent("CrowdCount")
            .appendingPathComponent("Analyses")
            .appendingPathComponent(id)
    }
}

final class PredictionModel: Object {
    @objc dynamic var classification: String = ""
    @objc dynamic var probability: Double = 0
    @objc dynamic var duration: Double = 0
    @objc dynamic var count: Double = 0

    static func from(_ prediction: PredictionRowViewModel) -> PredictionModel {
        let pm = PredictionModel()
        pm.classification = prediction.classification
        pm.probability = prediction.probability
        pm.duration = prediction.duration
        pm.count = prediction.count
        return pm
    }
}
