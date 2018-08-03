//
//  Realm.Configuration+migrations.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/3/18.
//  inspired by https://medium.com/@shenghuawu/realm-lightweight-migration-4559b9920487
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm.Configuration {
    typealias ShortMigrationBlock = (RealmSwift.Migration) -> Void

    static var crowdCountConfiguration: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: UInt64(migrations.count),
            migrationBlock: {
                let migration = $0
                let current = Int($1)
                migrations[current..<migrations.count]
                    .forEach { $0(migration) }
        })
    }

    private static let migrations: [ShortMigrationBlock] = [ { migration in
            migration.enumerateObjects(ofType: PredictionAnalysisModel.className()) { (_, new) in
                new?["id"] = UUID().uuidString
            }
        }
    ]

    static func nuke() {
        try? FileManager.default.removeItem(at: crowdCountConfiguration.fileURL!)
    }
}
