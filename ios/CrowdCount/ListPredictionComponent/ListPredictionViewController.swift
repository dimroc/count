//
//  ListPredictionViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/3/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import RealmSwift

class ListPredictionViewController: UITableViewController {
    var predictions = List<PredictionAnalysisModel>()
    var notificationToken: NotificationToken?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRealm()
        setupUI()
    }

    func setupUI() {
        title = "Prediction Analyses"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "analysisCell")
    }

    func setupRealm() {
        realm = try! Realm()

        notificationToken = realm.observe { _, _ in
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return dbPredictions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analysisCell", for: indexPath)
        let analysis: PredictionAnalysisModel = dbPredictions[dbPredictions.count - 1 - indexPath.row] // desc order
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ssa yyyy-MM-dd"
        cell.textLabel?.text = formatter.string(from: analysis.createdAt!)
        cell.imageView?.image = analysis.image(for: .original)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let analysis = ThreadSafeReference(to: dbPredictions[indexPath.row])
        NotificationCenter.default.post(name: .hydratePrediction, object: analysis)
    }

    private var dbPredictions: Results<PredictionAnalysisModel> {
        return realm.objects(PredictionAnalysisModel.self)
    }
}
