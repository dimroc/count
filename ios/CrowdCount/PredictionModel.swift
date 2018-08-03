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

final class PredictionModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var createdAt: Date?
    override static func primaryKey() -> String? {
        return "id"
    }

    static func from(_ image: UIImage, predictions: [PredictionRowViewModel]) -> PredictionModel {
        let pm = PredictionModel()
        pm.createdAt = Date()
        return pm
    }
}
